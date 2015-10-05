From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH 0/3] Small changes in headers
Date: Mon,  5 Oct 2015 16:50:08 +0200
Message-ID: <1444056611-7513-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is some changes for ioctls numbers declared outside of uapi, or not used
at all.


Gabriel Laskar (3):
  mce: change asm/ioctls.h for linux/ioctl.h
  msm: remove unused header
  falloc: expose ioctl numbers into uapi

 arch/x86/include/uapi/asm/mce.h |  2 +-
 include/linux/falloc.h          | 18 ----------
 include/linux/msm_mdp.h         | 79 -----------------------------------------
 include/uapi/linux/falloc.h     | 18 ++++++++++
 4 files changed, 19 insertions(+), 98 deletions(-)
 delete mode 100644 include/linux/msm_mdp.h

-- 
2.6.0
