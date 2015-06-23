From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH] st: convert to using driver attr groups for sysfs
Date: Tue, 23 Jun 2015 08:11:00 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BFF68D9@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
Cc: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This patch changes the st driver to use attribute groups so
driver sysfs files are created automatically. See the
following for reference:

http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
--- a/drivers/scsi/st.c	2015-06-22 14:20:40.829612661 -0500
+++ b/drivers/scsi/st.c	2015-06-22 15:49:49.357248393 -0500
@@ -85,6 +85,7 @@ static int debug_flag;
 
 static struct class st_sysfs_class;
 static const struct attribute_group *st_dev_groups[];
+static const struct attribute_group *st_drv_groups[];
 
 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI tape (st) driver");
@@ -198,15 +199,13 @@ static int sgl_unmap_user_pages(struct s
 static int st_probe(struct device *);
 static int st_remove(struct device *);
 
-static int do_create_sysfs_files(void);
-static void do_remove_sysfs_files(void);
-
 static struct scsi_driver st_template = {
 	.gendrv = {
 		.name		= "st",
 		.owner		= THIS_MODULE,
 		.probe		= st_probe,
 		.remove		= st_remove,
+		.groups		= st_drv_groups,
 	},
 };
 
@@ -4404,14 +4403,8 @@ static int __init init_st(void)
 	if (err)
 		goto err_chrdev;
 
-	err = do_create_sysfs_files();
-	if (err)
-		goto err_scsidrv;
-
 	return 0;
 
-err_scsidrv:
-	scsi_unregister_driver(&st_template.gendrv);
 err_chrdev:
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
@@ -4422,7 +4415,6 @@ err_class:
 
 static void __exit exit_st(void)
 {
-	do_remove_sysfs_files();
 	scsi_unregister_driver(&st_template.gendrv);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
@@ -4459,44 +4451,14 @@ static ssize_t st_version_show(struct de
 }
 static DRIVER_ATTR(version, S_IRUGO, st_version_show, NULL);
 
-static int do_create_sysfs_files(void)
-{
-	struct device_driver *sysfs = &st_template.gendrv;
-	int err;
-
-	err = driver_create_file(sysfs, &driver_attr_try_direct_io);
-	if (err)
-		return err;
-	err = driver_create_file(sysfs, &driver_attr_fixed_buffer_size);
-	if (err)
-		goto err_try_direct_io;
-	err = driver_create_file(sysfs, &driver_attr_max_sg_segs);
-	if (err)
-		goto err_attr_fixed_buf;
-	err = driver_create_file(sysfs, &driver_attr_version);
-	if (err)
-		goto err_attr_max_sg;
-
-	return 0;
-
-err_attr_max_sg:
-	driver_remove_file(sysfs, &driver_attr_max_sg_segs);
-err_attr_fixed_buf:
-	driver_remove_file(sysfs, &driver_attr_fixed_buffer_size);
-err_try_direct_io:
-	driver_remove_file(sysfs, &driver_attr_try_direct_io);
-	return err;
-}
-
-static void do_remove_sysfs_files(void)
-{
-	struct device_driver *sysfs = &st_template.gendrv;
-
-	driver_remove_file(sysfs, &driver_attr_version);
-	driver_remove_file(sysfs, &driver_attr_max_sg_segs);
-	driver_remove_file(sysfs, &driver_attr_fixed_buffer_size);
-	driver_remove_file(sysfs, &driver_attr_try_direct_io);
-}
+static struct attribute *st_drv_attrs[] = {
+	&driver_attr_try_direct_io.attr,
+	&driver_attr_fixed_buffer_size.attr,
+	&driver_attr_max_sg_segs.attr,
+	&driver_attr_version.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(st_drv);
 
 /* The sysfs simple class interface */
 static ssize_t
