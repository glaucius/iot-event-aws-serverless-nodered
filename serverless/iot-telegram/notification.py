import json
import telegram
import os
import logging

# Logging is cool!
logger = logging.getLogger()
if logger.handlers:
    for handler in logger.handlers:
        logger.removeHandler(handler)
logging.basicConfig(level=logging.INFO)

def configure_telegram():
    """
    Configures the bot with a Telegram Token.

    Returns a bot instance.
    """

    TELEGRAM_TOKEN = os.environ.get('TELEGRAM_TOKEN')
    if not TELEGRAM_TOKEN:
        logger.error('The TELEGRAM_TOKEN must be set')
        raise NotImplementedError

    return telegram.Bot(TELEGRAM_TOKEN)

def lambda_handler(event, context):
    # TODO implement
    thing = event['thing']
    temperatura = event['temperatura']
    humidade = event['humidade']
    localizacao = event['localizacao']
    ph = event['ph']
    nivelagua = event['nivelagua']
    co2 = event['co2']

    emoji_temperatura = u'\U0001F321'
    emoji_humidade = u'\U0001F4A7'


    if thing == "Onca Pintada":
    	emoji_thing = u'\U0001F406'
            mensagem = f'Atenção, algo anormal com a Onça Pintada {emoji_thing} :\n{emoji_temperatura}: {temperatura}\n{emoji_humidade}: {humidade}'
    if thing == "Ariranha":
        emoji_thing = u'\U0001F9A6'
            mensagem = f'Atenção, algo anormal com a Ariranha {emoji_thing} :\n{emoji_temperatura}: {temperatura}\n{emoji_humidade}: {humidade}'
    if thing == "Preguiça":
        emoji_thing = u'\U0001F9A5'
            mensagem = f'Atenção, algo anormal com o Preguiça {emoji_thing} :\n{emoji_temperatura}: {temperatura}\n{emoji_humidade}: {humidade}'
    if thing == "Unicornio":
        emoji_thing = u'\U0001F984'
            mensagem = f'Nãoooooooo, pare tudo e cuide do Unicornio !!! {emoji_thing} :\n{emoji_temperatura}: {temperatura}\n{emoji_humidade}: {humidade}'

    if thing == "SensorFogo":
        emoji_thing = u'\U0001F525'
            mensagem = f'{emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing} ALERTA DE FOGO {emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing}'

    if thing == "SensorAgua":
        emoji_thing = u'\U0001F39A'
            mensagem = f'{emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing} ALERTA DE AGUA {emoji_thing}{emoji_thing}{emoji_thing}{emoji_thing}'


    chat_id = os.environ.get('TELEGRAM_CHATID')
    bot = configure_telegram()
    logger.info('Event: {}'.format(event))
    bot.sendMessage(chat_id=chat_id, text=mensagem)
    logger.info('Message sent')    
    
    return {
        'statusCode': 200,
        'body': json.dumps(mensagem)
    }
