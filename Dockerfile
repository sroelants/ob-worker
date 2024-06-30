FROM python:3.10

# Fetch OB source
RUN git clone https://github.com/sroelants/OpenBench
WORKDIR OpenBench/Client

# Install python dependencies
RUN pip install -r requirements.txt

# Install cargo
RUN curl https://sh.rustup.rs -sSf >> rustup.sh \ 
  && chmod +x rustup.sh \
  && ./rustup.sh -y

# Source cargo env and run client
CMD . /root/.cargo/env; python3 -u client.py \ 
  --user sroelants \
  --password $OPENBENCH_PASSWORD \
  --server https://chess.samroelants.com \
  --threads 8 \
  --nsockets 1
