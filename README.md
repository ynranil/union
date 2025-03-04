# Union Ceremony Kurulum. 
### Contabo 5$ sunucu yeterli 

## Sunucuya bağlanıp komutu kullanın
```bash  
curl -s https://raw.githubusercontent.com/ynranil/union/refs/heads/main/g.sh -O && chmod +x g.sh && ./g.sh  
```  

## Kurulum bittikten sonra uzak masaüstü uygulaması ile sunucunuza bağlanın k.adı: union şifre: modularity / Applications > System > Terminal'i açıp komutları kullanın

```bash  
sudo apt update && sudo apt upgrade -y  
```  

```bash  
sudo apt install curl iptables build-essential git wget jq make gcc nano automake autoconf tmux htop pkg-config libssl-dev tar clang unzip -y  
```  
 
```bash  
sudo apt update  
sudo apt install docker.io -y  
```

```bash  
sudo su  
(Şifre sorucak: modularity)
```

```bash  

cd 
```  
```bash 
mkdir -p ceremony && docker pull ghcr.io/unionlabs/union/mpc-client:v1.2 && docker run -v $(pwd)/ceremony:/ceremony -w /ceremony -p 4919:4919 --rm -it ghcr.io/unionlabs/union/mpc-client:v1.2
```

## Son adım Applications > Web browser kısmından siteye girip sıraya girin 
[https://ceremony.union.build/](https://ceremony.union.build/)  

## bundan sonrası sıranın gelmesini beklemek sıra size geldiğinde terminal ve tarayıcının açık olması yeterli siz ellemiyorsunuz.
