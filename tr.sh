#!/bin/bash
set -euo pipefail

function prompt() {
  while true; do
    read -p "$1 [y/N] " yn
    case $yn in
    [Yy]) return 0 ;;
    [Nn] | "") return 1 ;;
    esac
  done
}

if [[ $(id -u) != 0 ]]; then
  echo Please run this script as root.
  exit 1
fi

if [[ $(uname -m 2>/dev/null) != x86_64 ]]; then
  echo Please run this script on x86_64 machine.
  exit 1
fi

NAME=trojan-go
TROJAN_GO_VER_LATEST=$(curl -fsSL https://api.github.com/repos/p4gefau1t/trojan-go/releases | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
DOWNLOADURL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VER_LATEST}/trojan-go-linux-amd64.zip"
TMPDIR="$(mktemp -d)"
INSTALLPREFIX=/usr/local
SYSTEMDPREFIX=/etc/systemd/system

BINARYPATH="${INSTALLPREFIX}/bin/${NAME}"
CONFIGPATH="${INSTALLPREFIX}/etc/${NAME}/config.json"
SYSTEMDPATH="${SYSTEMDPREFIX}/${NAME}.service"

  echo Entering temp directory ${TMPDIR}...
  cd ${TMPDIR}

  echo Downloading ${NAME} ${TROJAN_GO_VER_LATEST}...
  wget -q "${DOWNLOADURL}" -O trojan-go.zip
  unzip -q trojan-go.zip && rm -rf trojan-go.zip

  echo Installing ${NAME} ${TROJAN_GO_VER_LATEST} to ${BINARYPATH}...
  install -Dm755 "${NAME}" "${BINARYPATH}"

  echo Installing ${NAME} server config to ${CONFIGPATH}...
  if ! [[ -f "${CONFIGPATH}" ]] || prompt "The server config already exists in ${CONFIGPATH}, overwrite?"; then
    install -Dm644 examples/server.json-example "$CONFIGPATH"
  else
    echo Skipping installing ${NAME} server config...
  fi

  if [[ -d "${SYSTEMDPREFIX}" ]]; then
    echo Installing ${NAME} systemd service to ${SYSTEMDPATH}...
    if ! [[ -f "${SYSTEMDPATH}" ]] || prompt "The systemd service already exists in ${SYSTEMDPATH}, overwrite?"; then
      cat >"${SYSTEMDPATH}" <<EOF
[Unit]
Description=Trojan-Go - An unidentifiable mechanism that helps you bypass GFW
Documentation=https://p4gefau1t.github.io/trojan-go/
After=network.target network-online.target nss-lookup.target mysql.service mariadb.service mysqld.service
Wants=network-online.target

[Service]
Type=simple
User=root
StandardError=journal
ExecStart="${BINARYPATH}" -config "${CONFIGPATH}"
ExecReload=/bin/kill -HUP \$MAINPID
LimitNOFILE=51200
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
      echo Reloading systemd daemon...
      systemctl daemon-reload
    else
      echo Skipping installing $NAME systemd service...
    fi
  fi

  echo Updating geoip/geosite files...
  wget https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat -O ${INSTALLPREFIX}/etc/${NAME}/geosite.dat
  wget https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat -O ${INSTALLPREFIX}/etc/${NAME}/geoip.dat

  cd ~
  echo Deleting temp directory ${TMPDIR}...
  rm -rf "${TMPDIR}"
  
  echo done!