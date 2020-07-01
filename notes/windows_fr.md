Windows
=======

Backup
------

### rsync

Sauvegarder le dossier `D:\XXX` dans le disque `E:`

```
rsync -aHAXS --info=progress2 /mnt/d/XXX /mnt/e
```

Options (à ajouter juste après `rsync`):
- `-i` pour vérifier le contenu de tous les fichiers.
- `--delete` pour supprimer les fichiers en trop

