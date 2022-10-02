#usage: python3 calc_SSIM.py img_gold.jpg img_ax.jpg

import sys
import cv2

from skimage import metrics 

gold=sys.argv[1]
ax=sys.argv[2]

gold = cv2.imread(gold)
ax = cv2.imread(ax)
    
ssim=metrics.structural_similarity (gold, ax,multichannel=True)

print (ssim)
with open("ssim_out.txt", "w") as text_file:
    text_file.write("%f" % ssim)

