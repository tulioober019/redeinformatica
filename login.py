import pandas as pd

datos=pd.read_csv("datos.csv")

print(datos)

auth=False

try:
    while auth==False:
        login=input("Introduce tu nombre de usuario: ")
        contrasena=input("Introduce tu contraseña: ")

        datos_usuario=datos.loc[datos["usuario"]==login]

        if (login == datos_usuario["usuario"].values[0]) and (contrasena == datos_usuario["contrasena"].values[0]):
            auth=True

    if auth==True:
        print("Login correcto")

except IndexError:
    print("Usuario o contraseña no existe")
    auth=False