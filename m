From: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Documentation: rtc: move ioctl to ABI
Date: Mon, 1 Jan 2018 23:00:02 +0530
Message-ID: <cover.1514827586.git.aishpant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-rtc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

Two documentation changes in rtc:
1) Minor change to add file permissions to sysfs interface
2) Move ioctl interface to Documentation/ABI

Aishwarya Pant (2):
  Documentation: rtc: add sysfs file permissions
  Documentation: rtc: move iotcl interface documentation to ABI

 Documentation/ABI/testing/rtc-cdev        | 42 ++++++++++++++++++++++++++
 Documentation/ABI/testing/sysfs-class-rtc | 44 ++++++++++++++-------------
 Documentation/rtc.txt                     | 49 ++-----------------------------
 3 files changed, 67 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/ABI/testing/rtc-cdev

-- 
2.15.1
