import sys
import time
import psutil

def monitorar_processo(pid):
    try:
        processo = psutil.Process(pid)
        while True:
            uso_cpu = processo.cpu_percent(interval=1)
            uso_mem = processo.memory_percent()
            print(f"Processo: {pid} | CPU: {uso_cpu}% | Memória: {uso_mem}%")
            time.sleep(5)
    except psutil.NoSuchProcess:
        print(f"Processo {pid} não encontrado.")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python script.py <ID do processo>")
        sys.exit(1)

    pid = int(sys.argv[1])
    monitorar_processo(pid)
