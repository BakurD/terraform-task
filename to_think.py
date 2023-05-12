import requests
import json

# Введите свой API-ключ AdvancedHosting
API_KEY = 'your_api_key_here'

# Задайте имя DNS-записи и IP-адрес, к которому вы хотите привязать запись
DNS_RECORD_NAME = 'example.com'
IP_ADDRESS = '192.168.0.1'

# Определите URL-адрес и конечную точку API для получения списка DNS-зон
url = 'https://api.advancedhosting.com/v2/dnszones'

# Установите заголовок авторизации для запроса
headers = {'Authorization': f'Bearer {API_KEY}'}

# Выполните запрос для получения списка DNS-зон
response = requests.get(url, headers=headers)

# Распарсите JSON-ответ
json_data = json.loads(response.text)

# Найдите DNS-зону, в которой находится заданная DNS-запись
dns_zone_id = None
for dns_zone in json_data['data']:
    if DNS_RECORD_NAME.endswith(dns_zone['name']):
        dns_zone_id = dns_zone['id']
        break

# Если DNS-зона не найдена, выведите сообщение об ошибке
if dns_zone_id is None:
    print(f'DNS zone for {DNS_RECORD_NAME} not found.')
    exit()

# Определите URL-адрес и конечную точку API для получения списка DNS-записей в заданной DNS-зоне
url = f'https://api.advancedhosting.com/v2/dnszones/{dns_zone_id}/dnsrecords'

# Выполните запрос для получения списка DNS-записей в заданной DNS-зоне
response = requests.get(url, headers=headers)

# Распарсите JSON-ответ
json_data = json.loads(response.text)

# Найдите запись DNS, которую вы хотите изменить
dns_record_id = None
for dns_record in json_data['data']:
    if dns_record['name'] == DNS_RECORD_NAME and dns_record['type'] == 'A':
        dns_record_id = dns_record['id']
        break

# Если запись DNS не найдена, создайте новую запись
if dns_record_id is None:
    data = {
        'name': DNS_RECORD_NAME,
        'type': 'A',
        'content': IP_ADDRESS,
        'ttl': 300
    }
    response = requests.post(url, headers=headers, json=data)
    json_data = json.loads(response.text)
    dns_record_id = json_data['data']['id']
else:
    # Измените IP-адрес существующей записи DNS
    url = f'https://api
