
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

resource "aws_iot_topic_rule" "parque_nacional_regra_habitantes" {
  name        = "parque_nacional_regra_habitantes"
  description = "Monitoramento de condições fisiológicas"
  enabled     = true
  sql         = "SELECT * FROM 'habitante' where temperatura >= 39"
  sql_version = "2016-03-23"

  lambda {
    function_arn     = var.LAMBDA_FUNCTION_ARN
  }
}

resource "aws_iot_topic_rule" "parque_nacional_regra_queimadas" {
  name        = "parque_nacional_regra_queimada"
  description = "Monitoramento de queimadas e possibilidade de fogo"
  enabled     = true
  sql         = "SELECT * FROM 'queimadas' where co2 >= 7"
  sql_version = "2016-03-23"

  lambda {
    function_arn     = lambda.notifications.arn
  }
}

resource "aws_iot_topic_rule" "parque_nacional_regra_aguas" {
  name        = "parque_nacional_regra_agua"
  description = "Monitoramento da qualidade da água nos locais monitorados"
  enabled     = true
  sql         = "SELECT * FROM 'aguas' where ph >= 5 or ph >= 8,5"
  sql_version = "2016-03-23"

  lambda {
    function_arn     = lambda.notifications.arn
  }
}