import requests
import subprocess

def test_reverse_proxy():
    try:
        response = requests.get('http://localhost:80')
        if response.status_code == 200:
            print("Reverse proxy is working correctly.")
        else:
            print(f"Reverse proxy returned status code {response.status_code}.")
    except requests.exceptions.RequestException as e:
        print(f"Failed to connect to reverse proxy: {e}")

def test_web_service():
    try:
        response = requests.get('http://localhost:5000')
        if response.status_code == 200:
            print("Web service is working correctly.")
        else:
            print(f"Web service returned status code {response.status_code}.")
    except requests.exceptions.RequestException as e:
        print(f"Failed to connect to web service: {e}")

def test_firewall(container_name, target_ip, target_port):
    try:
        result = subprocess.run(
            ["docker", "exec", container_name, "nc", "-zv", target_ip, str(target_port)],
            capture_output=True, text=True
        )
        if result.returncode == 0:
            print(f"Firewall test passed: {container_name} can connect to {target_ip}:{target_port}")
        else:
            print(f"Firewall test failed: {container_name} cannot connect to {target_ip}:{target_port}")
            print(result.stderr)
    except Exception as e:
        print(f"Failed to execute firewall test: {e}")

if __name__ == "__main__":
    print("Testing reverse proxy...")
    test_reverse_proxy()
    
    print("Testing web service...")
    test_web_service()
    
    print("Testing firewall from firewall_dmz to web service...")
    test_firewall("firewall_dmz", "web", 5000)
    
    print("Testing firewall from firewall_mz to db service...")
    test_firewall("firewall_mz", "db", 3306)