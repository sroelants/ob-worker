FROM python:3.10

RUN git clone https://github.com/sroelants/OpenBench
WORKDIR OpenBench/Client

RUN pip install -r requirements.txt
# CMD ["python3", "-u", "client.py", "-P", $OPENBENCH_PASSWORD, "--threads", "12", "--nsockets", "1"]
CMD python3 -u client.py \ 
  --user sroelants \
  --password $OPENBENCH_PASSWORD \
  --server https://chess.samroelants.com \
  --threads 12 \
  --nsockets 1
