
# A coisa
resource "aws_iot_thing" "parque_nacional" {

  name = "parque_nacional"

}

# Policy e certificado

resource "aws_iot_policy" "parque_nacional_policy" {
  name = "parque_nacional_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iot:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iot_certificate" "parque_nacional_cert" {
  csr    = file("thing.csr")
  active = true
}

resource "aws_iot_policy_attachment" "parque_nacional_policy_att" {
  policy = aws_iot_policy.parque_nacional_policy.name
  target = aws_iot_certificate.parque_nacional_cert.arn
}

resource "aws_iot_thing_principal_attachment" "parque_nacional_thing_att" {
  principal = aws_iot_certificate.parque_nacional_cert.arn
  thing     = aws_iot_thing.parque_nacional.name
}


### Rule - Regras - Topic

resource "aws_iot_topic_rule" "parque_nacional_regra" {
  name        = "parque_nacional_regra"
  description = "Regra para disparar função lambda"
  enabled     = true
  sql         = "SELECT * FROM 'hospedes' where temperatura >= 39"
  sql_version = "2016-03-23"

  lambda {
    function_arn     = "arn:aws:lambda:us-east-1:994210910568:function:iot-telegram-dev-notification"
  }
}

