#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#define BUFLEN 4096
const ssize_t headerStrLen = 4;
const static char headerString[] = "KAGZ";
const ssize_t headerFLLen = 4;

static int ulong2BigEndian(unsigned char*big,off_t len)
{
  unsigned long l = len;
  if(big == NULL){
    return -1;
  }
  big[0] = (l>>24);
  big[1] = (l>>16)&0xff;
  big[2] = (l>>8)&0xff;
  big[3] = l&0xff;
}

int main(int argc,char* argv[])
{
  int ret = 0;
  if(argc!=3){
    printf("Usage : addPQIHeader inputfile outputfile\n");
    ret = 1;
    goto errorExit;
  }
  int ifd = open(argv[1],O_RDONLY);
  if(ifd<0){
    printf("File open error %s\n",argv[1]);
    ret = 2;
    goto errorExit;
  }
  off_t fileLength = lseek(ifd,0,SEEK_END);
  lseek(ifd,0,SEEK_SET);
  if(fileLength > 0x100000000LL){
    printf("File is too big for convert. Max length 0x100000000(4G)Bytes\n");
    ret = 3;
    goto errorExit;
  }
  int ofd = open(argv[2],O_WRONLY|O_CREAT|O_TRUNC,0666);
  if(ofd<0){
    printf("File create error %s\n",argv[2]);
    ret = 4;
    goto exitifd;
  }
  unsigned char bigEndian[4];
  ulong2BigEndian(bigEndian,fileLength);
  write(ofd,headerString,headerStrLen);
  write(ofd,bigEndian,headerFLLen);
  unsigned char buf[BUFLEN];
  while(1){
    ssize_t len = read(ifd,buf,BUFLEN);
    if(len==0){
      break;
    }else if(len<0){
      printf("File read error %d\n",(int)len);
      ret = 5;
      break;
    }else{
      write(ofd,buf,len);
    }
  }
 exitofd:
  close(ofd);
 exitifd:
  close(ifd);
 errorExit:
  return ret;
}
