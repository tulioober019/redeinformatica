# Creacion de la función fibonacchi en python.
def fibonnachi(n):
    a0=0
    a1=1
    a2=a0+a1
    contador=0

    if (n==0):
        return a0
    elif (n==1):
        return a1
    elif (n==2):
        return a2
    else:
        while (contador<=(n-3)):
            a0=a1
            a1=a2
            a2=a0+a1
            contador=contador+1
        return a2

# Función de fibonacchi en accion.
contador2=0
while contador2<20:
    print(
        fibonnachi(contador2)
    )
    contador2=contador2+1