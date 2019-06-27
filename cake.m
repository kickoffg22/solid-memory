function Cake = cake(min_dist)
    % Die Funktion cake erstellt eine "Kuchenmatrix", die eine kreisfoermige
    % Anordnung von Nullen beinhaltet und den Rest der Matrix mit Einsen
    % auffuellt. Damit koennen, ausgehend vom staerksten Merkmal, andere Punkte
    % unterdrueckt werden, die den Mindestabstand hierzu nicht einhalten. 
    [X_cake,Y_cake] = meshgrid(-min_dist:min_dist,-min_dist:min_dist);
    Cake = X_cake.^2+Y_cake.^2>min_dist^2;    
end