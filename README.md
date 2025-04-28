# HTB Machines 🔎

Este proyecto es un script en Bash para buscar información sobre máquinas de Hack The Box resueltas, basándose en el dataset público de **s4vitar**
 ('https://htbmachines.github.io').

Permite buscar máquinas según múltiples criterios como nombre, IP, sistema operativo, skill, dificultad, y certificaciones, entre otros.

---

## 🚀 Funcionalidades

- Actualizar el dataset descargado.
- Buscar máquinas por:
  - Nombre
  - Dirección IP
  - Sistema Operativo
  - Dificultad
  - Skill
  - Certificación
 - Obtener enlaces de tutoriales de resolución en YouTube.
 - Por sistema operativo y por dificultad

---

## 📚 Uso

---bash---
chmod +x htbmachines.sh

./htbmachines.sh -h

📥 Opciones disponibles

Opción		Descripción
-u	Descargar o actualizar archivos necesarios
-m <nombre>	Buscar por nombre de máquina
-i <IP>	Buscar por dirección IP
-o <SO>	Buscar por sistema operativo
-s <skill>	Buscar por skill
-c <certificación>	Buscar por certificación
-y <nombre>	Obtener link de resolución en YouTube
-d <dificultad>	Buscar máquinas por dificultad
-h	Mostrar el panel de ayuda

🔥 Requisitos

Bash

curl

js-beautify

moreutils (para sponge)

Se pueden instalar en Debian/Ubuntu con:
sudo apt install curl moreutils
sudo npm install -g js-beautify

🤝 Créditos
Este proyecto fue inspirado gracias al contenido del curso de Hack4u de S4vitar.

🧑‍💻 Autor
Rodrigo Inzaurralde




