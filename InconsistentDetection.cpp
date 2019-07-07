//
//  InconsistentDetection.cpp

#include <stdio.h>
#include "cv.h"
#include "highgui.h"
using namespace cv;
using namespace std;


void InconDet(Mat &disp,Mat &occp)
{
    int serc_rang=16;
    int edgeThresh=19;
    int wid=disp.cols;
    int hei=disp.rows;;
    
    // Mean shift
    IplImage *img0=cvLoadImage(leftPath);
    IplImage* Y = cvCreateImage(cvGetSize(img0),IPL_DEPTH_8U,1);
    IplImage* Cb= cvCreateImage(cvGetSize(img0),IPL_DEPTH_8U,1);
    IplImage* Cr = cvCreateImage(cvGetSize(img0),IPL_DEPTH_8U,1);
    IplImage* dst1=cvCreateImage(cvGetSize(img0),IPL_DEPTH_8U,3);
    cvCvtColor(img0,dst1,CV_BGR2YCrCb);
    cvSplit(dst1,Y,Cb,Cr,0);
    cvEqualizeHist(Y,Y);
    IplImage* img=cvCreateImage(cvGetSize(img0),IPL_DEPTH_8U,3);
    cvMerge(Y,Cb,Cr,0,img);
    cvCvtColor(img,img,CV_YCrCb2BGR);
    
    int **comp = new int *[hei];
    for(int i=0;i<hei;i++)
        comp[i] = new int [wid];
    int regionCount = MeanShift(img,comp);
    
    //edge
    Mat image2,edges;
    image2 = disp.clone(); image2*=SCALE;
    blur(image2,image2,Size(3,3));
    Canny(image2,edges,edgeThresh,edgeThresh*3,3);
    for(int i=0;i<hei;i++)
    {
        uchar *pe=edges.ptr<uchar>(i);
        for(int j=0;j<wid;j++)
        {
            if(pe[j]==255)
            {
                int fl=comp[i][j];
                if(comp[MAX(i-1,0)][j]==fl && comp[MIN(i+1,hei-1)][j]==fl && comp[i][MAX(j-1,0)]==fl && comp[i][MIN(j+1,wid-1)]==fl)
                    pe[j]=255;
                else
                    pe[j]=0;
            }
        }//j
    }//i
    //imshow("edges",edges);
    
    //search
    for(int i=0;i<hei;i++)
    {
        uchar *pe=edges.ptr<uchar>(i);
        for(int j=0;j<wid;j++)
        {
            if(pe[j]==255)//mis edg
            {
                ///////////////////////////////////////////////////////////////////////////////////////////////
                if(disp.at<uchar>(MAX(i-1,0),j) != disp.at<uchar>(MIN(i+1,hei-1),j))//vertical
                {
                    int sum_up=0,sum_dn=0;
                    while((i-sum_up>=0) && (comp[i-sum_up][j]==comp[i][j]))
                        sum_up++;
                    while((i+sum_dn<hei) && (comp[i+sum_dn][j]==comp[i][j]))
                        sum_dn++;
                    if(sum_up<sum_dn)//up
                    {
                        for(int s_up=i;s_up>=MAX(i-serc_rang,0);s_up--)
                        {
                            if(comp[s_up][j] == comp[i][j])
                                occp.at<uchar>(s_up,j)=1;
                            else
                                break;
                        }
                    }//up
                    else//down
                    {
                        for(int s_dn=i;s_dn<=MIN(i+serc_rang,hei-1);s_dn++)
                        {
                            if(comp[s_dn][j] == comp[i][j])
                                occp.at<uchar>(s_dn,j)=1;
                            else
                                break;
                        }
                    }//down
                }//vertical
                else//horizontal
                {
                    int sum_lt=0,sum_rt=0;
                    while((j-sum_lt>=0) && (comp[i][j-sum_lt]==comp[i][j]))
                        sum_lt++;
                    while((j+sum_rt<wid) && (comp[i][j+sum_rt]==comp[i][j]))
                        sum_rt++;
                    if(sum_lt<sum_rt)//left
                    {
                        for(int s_lf=j;s_lf>=MAX(j-serc_rang,0);s_lf--)
                        {
                            if(comp[i][s_lf] == comp[i][j])
                                occp.at<uchar>(i,s_lf)=1;
                            else
                                break;
                        }
                    }//left
                    else//right
                    {
                        for(int s_rt=j;s_rt<=MIN(j+serc_rang,wid-1);s_rt++)
                        {
                            if(comp[i][s_rt] == comp[i][j])
                                occp.at<uchar>(i,s_rt)=1;
                            else
                                break;
                        }
                    }//right
                }//horizontal
            }//mis edg
        }//j
    }//i
    //imshow("occp",occp*255);//waitKey();
    for(int i=0;i<hei;i++)
    {
        delete [wid]comp[i];
        comp[i]=NULL;
    }
    delete [hei]comp;
    comp=NULL;
}
