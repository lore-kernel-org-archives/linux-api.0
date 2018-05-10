From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 1/2 V2] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Date: Thu, 10 May 2018 13:13:57 -0500
Message-ID: <4a4f33c3-2173-9795-f4e4-1e9d338fd9a7@sandeen.net>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Move the btrfs label ioctls up to the vfs for general use.

This retains 256 chars as the maximum size through the interface, which
is the btrfs limit and AFAIK exceeds any other filesystem's maximum
label size.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: David Sterba <dsterba@suse.com>
---

V2: note that hoisted btrfs ioctls exist in ioctl-number.txt, new since
    reviews but I took a little license.

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 84bb74dcae12..1299df349b71 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -298,7 +298,8 @@ Code  Seq#(hex)	Include File		Comments
 0x90	00	drivers/cdrom/sbpcd.h
 0x92	00-0F	drivers/usb/mon/mon_bin.c
 0x93	60-7F	linux/auto_fs.h
-0x94	all	fs/btrfs/ioctl.h
+0x94	all	fs/btrfs/ioctl.h	Btrfs filesystem
+		and linux/fs.h		some lifted to vfs
 0x97	00-7F	fs/ceph/ioctl.h		Ceph file system
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 632e26d6f7ce..8feea790bd00 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5444,6 +5444,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_setflags(file, argp);
 	case FS_IOC_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
+	case FS_IOC_GETFSLABEL:
+		return btrfs_ioctl_get_fslabel(file, argp);
+	case FS_IOC_SETFSLABEL:
+		return btrfs_ioctl_set_fslabel(file, argp);
 	case FITRIM:
 		return btrfs_ioctl_fitrim(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
@@ -5555,10 +5559,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_quota_rescan_wait(file, argp);
 	case BTRFS_IOC_DEV_REPLACE:
 		return btrfs_ioctl_dev_replace(fs_info, argp);
-	case BTRFS_IOC_GET_FSLABEL:
-		return btrfs_ioctl_get_fslabel(file, argp);
-	case BTRFS_IOC_SET_FSLABEL:
-		return btrfs_ioctl_set_fslabel(file, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index c8d99b9ca550..af29cc9032a2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -823,10 +823,8 @@ enum btrfs_err_code {
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
-#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
-				   char[BTRFS_LABEL_SIZE])
-#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
-				   char[BTRFS_LABEL_SIZE])
+#define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GETFSLABEL
+#define BTRFS_IOC_SET_FSLABEL	FS_IOC_SETFSLABEL
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index d2a8313fabd7..9d132f8f2df8 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -242,6 +242,8 @@ struct fsxattr {
 #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
 #define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
 
+#define FSLABEL_MAX 256	/* Max chars for the interface; each fs may differ */
+
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
@@ -251,8 +253,10 @@ struct fsxattr {
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
-#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
-#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
+#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+#define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
+#define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 
 /*
  * File system encryption support


