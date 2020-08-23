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
    humidade = event['humidade']
    temperatura = event['temperatura']
    hospede = event['hospede']
    emoji_temperatura = u'\U0001F321'
    emoji_humidade = u'\U0001F4A7'
    if hospede == "Porco":
    	emoji = u'\U0001F437' 
    if hospede == "Porca":
    	emoji = u'\U0001F437' 
    if hospede == "Cavalo":
    	emoji = u'\U0001F434' 
    if hospede == "Egua":
    	emoji = u'\U0001F434' 
    if hospede == "Vaca":
    	emoji = u'\U0001F42E' 
    if hospede == "Boi":
    	emoji = u'\U0001F42E' 
    mensagem = f'Sua atenção é necessária:\n{emoji}: {hospede}\n{emoji_temperatura}: {temperatura}\n{emoji_humidade}: {humidade}'
    chat_id = os.environ.get('TELEGRAM_CHATID')
    bot = configure_telegram()
    logger.info('Event: {}'.format(event))
    bot.sendMessage(chat_id=chat_id, text=mensagem)
    logger.info('Message sent')    
    
    return {
        'statusCode': 200,
        'body': json.dumps(mensagem)
    }
