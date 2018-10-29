require 'terminal-table'

cola_autores = {
    tope: nil,
    fondo: nil,
    max: 5
}

cola_ventas = {
    tope: nil,
    fondo: nil,
    codigo: 0,
    max: 20
}

def size(cola)
    tamano = 0
    a = cola[:tope]
    while a != nil
        tamano += 1
        a = a[:siguiente]
    end
    return tamano
end

def llena?(cola)
    if size(cola) == cola[:max]
        return true
    else
        return false
    end
end

def vacia?(cp)
    if cp[:tope] == nil
        return true
    else
        return false
    end
end

def limpiar
    system('clear')
end

def continuar
    puts ''
    puts 'Pulse enter para continuar'
    gets
    system('clear')
end

def buscar(cp, buscado, tipo)
    a = cp[:tope]
    while a != nil
        if a[tipo] == buscado
            break
        else
            a = a[:siguiente]
        end
    end
    return a
end

def buscar_libro(cola_autores, isbn)
    a = cola_autores[:tope]
    while a != nil
        if buscar(a,isbn,:isbn) == nil
            a = a[:siguiente]
        else
            a = buscar(a,isbn,:isbn)
            break
        end
    end
    return a
end

def insertar_cola(cola, elemento)
    a = cola[:tope]
    begin
        if a == nil
            cola[:tope] = elemento
            cola[:fondo] = elemento
            break
        elsif a[:siguiente] == nil
            a[:siguiente] = elemento
            cola[:fondo] = elemento
            break
        else
            a = a[:siguiente]
        end
    end while a != nil
end

def registro_libros(cola_autores)
    puts 'Ingrese el ISBN:'
    isbn = gets.chomp.to_i

    a = buscar_libro(cola_autores, isbn) 
    if a != nil
        a[:existencias] += 1
        puts 'Se ha encontrado el libro y se han incrementado sus existencias'
        return
    else
        puts 'Ingrese nombre del autor:'
        autor = gets.chomp
        if buscar(cola_autores,autor,:nombre) == nil && llena?(cola_autores) == true
            puts 'Este autor no esta registrado y su cola ya esta llena'
            return
        end
    end

    puts 'Ingrese nombre del libro:'
    nombre = gets.chomp
    puts 'Ingrese el precio:'
    precio = gets.chomp.to_i
    puts 'Libro exitosamente registrado'

    a = cola_autores[:tope]
    
    elementolibro = {
        nombre: nombre,
        existencias: 1,
        precio: precio,
        isbn: isbn,
        autor: autor,
        siguiente: nil
    }
    pilaautor = {
        nombre: autor,
        tope: elementolibro,
        siguiente: nil
    }

    begin
        if a == nil
            cola_autores[:tope] = pilaautor
            cola_autores[:fondo] = pilaautor
            return
        elsif a[:nombre] == autor
            break
        elsif a[:siguiente] == nil
            a[:siguiente] = pilaautor
            cola_autores[:fondo] = pilaautor
            return
        else
            a = a[:siguiente]
        end
    end while a != nil

    b = a[:tope]
    begin
        if b == nil
            a[:tope] = elementolibro
            break
        elsif b[:siguiente] == nil
            elementolibro[:siguiente] = a[:tope]
            a[:tope] = elementolibro
            break
        else
            b = b[:siguiente]
        end
    end while b != nil
end

def registro_autores(cola_autores)
    if llena?(cola_autores) == true
        puts 'Su cola de autores ya esta llena'
    else
        puts 'Ingrese nombre del autor'
        nombre = gets.chomp

        a = buscar(cola_autores,nombre,:nombre)
        if a != nil
            puts 'Este autor ya existe'            
            return
        end

        pilaautor = {
            nombre: nombre,
            tope: nil,
            siguiente: nil
        }

        insertar_cola(cola_autores, pilaautor)
        puts 'Autor exitosamente registrado'
    end
end

def listado_libros(cola_autores)
    a = cola_autores[:tope]
    rows = []
    while a != nil
        b = a[:tope]
        while b != nil
            rows << [b[:isbn], b[:nombre], b[:precio], b[:existencias], a[:nombre]]
            b = b[:siguiente]
        end
        a = a[:siguiente]
    end
    table = Terminal::Table.new :rows => rows
    table.headings = ['ISBN', 'Nombre', 'Precio','Existencias', 'Autor']
    puts table
end

def listado_autores(cola_autores)
    if vacia?(cola_autores) == true
        puts 'La cola de autores esta vacia'
        return
    end
    a = cola_autores[:tope]
    rows = []
    while a != nil
        b = a[:tope]
        existencias = 0
        while b != nil
            existencias += 1
            b = b[:siguiente]
        end
        rows << [ a[:nombre], existencias]
        a = a[:siguiente]
    end
    table = Terminal::Table.new :rows => rows
    table.headings = ['Autor', 'Existencias']
    puts table
end

def ingreso_buscar_libro(cola_autores)
    rows = []
    if vacia?(cola_autores)
        puts 'Su base de datos esta vacia'
    else
        puts 'Ingrese el ISBN del libro buscado:'
        isbn = gets.chomp.to_i
        a = buscar_libro(cola_autores, isbn)
        if a == nil
            puts 'Este libro no esta registrado'
        else
        rows << [a[:nombre], a[:existencias], isbn, a[:precio],a[:autor]]
        table = Terminal::Table.new :rows => rows 
        table.headings = ['Nombre', 'Existencia', 'ISBN', 'Precio', 'Autor']
        puts table
        end
    end
end

def ingreso_buscar_autor(cola_autores)
    if vacia?(cola_autores) == true
        puts 'Su base de datos esta vacia'
    else
        puts 'Ingrese nombre del autor: '
        nombreautor = gets.chomp
        a = buscar(cola_autores, nombreautor, :nombre)
        if a == nil
            puts 'Este autor no existe'
            return
        end
        if vacia?(a) == true
            puts 'Este autor aun no tiene libros'
            return
        end
        elemento = {}
        aux = cola_autores[:tope]
        rows = []
    loop do
        if  nombreautor == aux[:nombre]
            elemento = aux
            break
        elsif aux[:siguiente] == nil
            break
        else
            aux = aux[:siguiente]
        end
    end
    puts "Autor: #{elemento[:nombre]}"
    elemento = elemento[:tope]
    
    loop do
        rows << [elemento[:nombre], elemento[:existencias]]
        elemento = elemento[:siguiente]
        if elemento == nil
            break
        end
    end
    table = Terminal::Table.new :rows => rows 
    table.headings = ['Libros', 'Existencias']
    puts table
    end
end



















begin
    limpiar
    puts 'Bienvenido a la base de datos "Ruby Bookstore"'
    puts 'Administración de libros'
    puts ' 1. Registro de nuevos libros'
    puts ' 2. Registro de autores'
    puts ' 3. Listado de libros'
    puts ' 4. Listado de autores'
    puts ' 5. Buscar libro'
    puts ' 6. Buscar autor'
    puts 'Control de ventas'
    puts ' 7. Registrar una venta'
    puts ' 8. Buscar una venta'
    puts ' 9. Listado de ventas'
    puts '10. Salir'

    n = gets.chomp.to_i

    if n == 1
        limpiar
        registro_libros(cola_autores)
        continuar
    elsif n == 2
        limpiar
        registro_autores(cola_autores)
        continuar
    elsif n == 3
        limpiar
        listado_libros(cola_autores)
        continuar
    elsif n == 4
        limpiar
        listado_autores(cola_autores)
        continuar
    elsif n == 5
        limpiar
        ingreso_buscar_libro(cola_autores)
        continuar
    elsif n == 6
        limpiar
        ingreso_buscar_autor(cola_autores)
        continuar
    elsif n == 7
        limpiar
        registro_ventas(cola_autores, cola_ventas)
        continuar
    elsif n == 8
        limpiar
        ingreso_buscar_venta(cola_ventas)
        continuar
    elsif n == 9
        limpiar
        listado_ventas(cola_ventas)
        continuar
    elsif n == 10
        limpiar
        puts 'Que tenga un buen dia'
    else
        puts 'Opcion invalida'
        continuar
    end
end while n != 10