# LaboNotification

1- In the package.yml, in the dependencies section add:
- HaskellNet
- HaskellNet-SSL
- bytestring
- text
2- open the following link: https://github.com/dpwright/HaskellNet-SSL
go to example folder and open gmail.hs file. There, there is an example.

3- Use this example by replacing the corresponding username, recipien, password with yours.
3.1- username : it is the username of gmail API. It is an email. 
an on that email account you need to you need to make some configuration 
as explained on this link: 
https://medium.com/graymatrix/using-gmail-smtp-server-to-send-email-in-laravel-91c0800f9662
3.2- password: it is the password you obtain on the above configuraton. 



Curl call: curl -X POST -F persdonnees='{"emailDestinataire":"didnkallaehawe@gmail.com", "nomDestinataire": "Nkalla Ehawe", "subject": "Job Test", "plainText": "The content", "htmlText": "<h1>The Html Content</h1> please clic on this link : <a href=\"http://localhost\">Labogenie</a>"}' -F secret=@/home/nkalla/Documents/Books/0321834577.pdf   http://127.0.0.1:8080

nkalla@nkalla-ehawe:~$ curl -X POST -F persdonnees='{"emailDestinataire":"stephanetsaguewamba@gmail.com", "nomDestinataire": "Tsague Stephane", "subject": "Acces au resultat au Labo Emergence Sante", "plainText": "Prendre soin de vous est notre priorite. Merci de nous voir choisi. Pour acceder a vos resultats utiliser votre comme identifiant Tsague Stephane et comme mot de passe 020304", "htmlText": "<h1>The Html Content</h1> please clic on this link : <a href=\"http://localhost\">Labogenie</a>"}' -F secret=@/home/nkalla/Documents/Books/0321834577.pdf   http://127.0.0.1:8080

