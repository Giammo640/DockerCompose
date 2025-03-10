import subprocess

def run_command(command):
    try:
        result = subprocess.run(command, shell=True, text=True, capture_output=True)
        return result.stdout.strip(), result.stderr.strip()
    except Exception as e:
        return "ERROR", str(e)

def check_containers():
    output, error = run_command("sudo docker ps --format '{{.Names}}'")
    if error:
        print(f"Error: {error}")
    else:
        print(f"Containers:\n{output}")

def test_connectivity():
    print("\nTesting connectivity...")

    tests = [
        ("client1", "ping -c 3 google.com"),  # Test di accesso a Internet
        ("client3", "ping -c 3 facebook.com"),  # Test di accesso a Internet
        ("client3", "ping -c 3 google.com"),  # Test di accesso a Internet
        ("client2", "nc -zv db 3306"),  # Test connessione al DB
        ("firewall_mz", "iptables -L -v -n"),  # Stato del firewall MZ
        ("firewall_dmz", "iptables -L -v -n"),  # Stato del firewall DMZ
        ("db", "mysqladmin ping -h localhost -u user --password=password"),  # Test MySQL
    ]

    for container, command in tests:
        print(f"\nTesting in: {container}, Command: {command}")
        complete_command = f"sudo docker exec -it {container} sh -c '{command}'"
        print(f"Complete command: {complete_command}")
        output, error = run_command(complete_command)
        if error:
            print(f"Error: {error}")
        else:
            print(f"Output:\n{output}")

if __name__ == "__main__":
    check_containers()
    test_connectivity()