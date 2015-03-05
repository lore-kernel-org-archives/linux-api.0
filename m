From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCHv2 0/2] N900 Modem Speech Support
Date: Thu, 5 Mar 2015 12:30:13 +0100
Message-ID: <20150305113013.GA3867@amd>
References: <1425343454-6551-1-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425343454-6551-1-git-send-email-sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>, Kai Vehmanen <kvcontact-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>, Pali Rohar <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>, Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi!

> Userland access goes via /dev/cmt_speech. The API is implemented in
> libcmtspeechdata, which is used by ofono and the freesmartphone.org project.
> Apart from that the device is also used by the phone binaries distributed
> with Maemo. So while this is a new userland ABI for the mainline kernel it
> has been tested in the wild for some years.

I'm sorry, Dave. I can't let you do that.

Yes, the ABI is "tested" for some years, but it is not documented, and
it is very wrong ABI.

I'm not sure what they do with the "read()". I was assuming it is
meant for passing voice data, but it can return at most 4 bytes,
AFAICT.

We already have perfectly good ABI for passing voice data around. It
is called "ALSA". libcmtspeech will then become unneccessary, and the
daemon routing voice data will be as simple as "read sample from
ALSA/modem, write sample to ALSA/rx-51_soundcard" & "read sample from
ALSA/rx-51_soundcard, write sample to ALSA/modem" & .

Should this driver be merged to drivers/staging while the interface is
fixed? Big part of driver should stay the same, userspace interface is
only small part of the driver...

Sorry about that,
									Pavel

Signed-off-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 5dbbc67..06dc81c 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -21,6 +21,8 @@
  * 02110-1301 USA
  */
 
+/* Thanks to http://ben-collins.blogspot.cz/2010/05/writing-alsa-driver-basics.html */
+
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -39,6 +41,11 @@
 #include <linux/hsi/ssi_protocol.h>
 #include <linux/hsi/cs-protocol.h>
 
+#include <sound/initval.h>
+#include <sound/core.h>
+#include <sound/memalloc.h>
+#include <sound/pcm.h>
+
 #define CS_MMAP_SIZE	PAGE_SIZE
 
 struct char_queue {
@@ -62,8 +69,12 @@ struct cs_char {
 	/* hsi channel ids */
 	int                     channel_id_cmd;
 	int                     channel_id_data;
+	/* alsa */
+	struct snd_card *card;
 };
 
+#define cs_char cs_char
+
 #define SSI_CHANNEL_STATE_READING	1
 #define SSI_CHANNEL_STATE_WRITING	(1 << 1)
 #define SSI_CHANNEL_STATE_POLL		(1 << 2)
@@ -168,6 +179,8 @@ static void cs_notify(u32 message, struct list_head *head)
 	wake_up_interruptible(&cs_char_data.wait);
 	kill_fasync(&cs_char_data.async_queue, SIGIO, POLL_IN);
 
+	/* snd_pcm_period_elapsed(my_dev->ss); ?? FIXME */
+
 out:
 	return;
 }
@@ -1134,10 +1147,8 @@ static unsigned int cs_char_poll(struct file *file, poll_table *wait)
 	return ret;
 }
 
-static ssize_t cs_char_read(struct file *file, char __user *buf, size_t count,
-								loff_t *unused)
+static ssize_t __cs_char_read(struct cs_char *csdata, char __user *buf, size_t count, int nonblock)
 {
-	struct cs_char *csdata = file->private_data;
 	u32 data;
 	ssize_t retval;
 
@@ -1161,7 +1172,7 @@ static ssize_t cs_char_read(struct file *file, char __user *buf, size_t count,
 
 		if (data)
 			break;
-		if (file->f_flags & O_NONBLOCK) {
+		if (nonblock) {
 			retval = -EAGAIN;
 			goto out;
 		} else if (signal_pending(current)) {
@@ -1182,10 +1193,17 @@ out:
 	return retval;
 }
 
-static ssize_t cs_char_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *unused)
+
+static ssize_t cs_char_read(struct file *file, char __user *buf, size_t count,
+								loff_t *unused)
 {
 	struct cs_char *csdata = file->private_data;
+	return __cs_char_read(csdata, buf, count, file->f_flags & O_NONBLOCK);
+}
+
+static ssize_t __cs_char_write(struct cs_char *csdata, const char __user *buf,
+						size_t count)
+{
 	u32 data;
 	int err;
 	ssize_t	retval;
@@ -1205,6 +1223,13 @@ static ssize_t cs_char_write(struct file *file, const char __user *buf,
 	return retval;
 }
 
+static ssize_t cs_char_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *unused)
+{
+	struct cs_char *csdata = file->private_data;
+	return __cs_char_write(csdata, buf, count);
+}
+
 static long cs_char_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
@@ -1269,7 +1294,7 @@ static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int cs_char_open(struct inode *unused, struct file *file)
+static int __cs_char_open(void)
 {
 	int ret = 0;
 	unsigned long p;
@@ -1300,8 +1325,6 @@ static int cs_char_open(struct inode *unused, struct file *file)
 	cs_char_data.mmap_base = p;
 	cs_char_data.mmap_size = CS_MMAP_SIZE;
 
-	file->private_data = &cs_char_data;
-
 	return 0;
 
 out3:
@@ -1314,6 +1337,13 @@ out1:
 	return ret;
 }
 
+static int cs_char_open(struct inode *unused, struct file *file)
+{
+	file->private_data = &cs_char_data;
+
+	return __cs_char_open();
+}
+
 static void cs_free_char_queue(struct list_head *head)
 {
 	struct char_queue *entry;
@@ -1329,10 +1359,8 @@ static void cs_free_char_queue(struct list_head *head)
 
 }
 
-static int cs_char_release(struct inode *unused, struct file *file)
+static int __cs_char_release(struct cs_char *csdata)
 {
-	struct cs_char *csdata = file->private_data;
-
 	cs_hsi_stop(csdata->hi);
 	spin_lock_bh(&csdata->lock);
 	csdata->hi = NULL;
@@ -1345,6 +1373,13 @@ static int cs_char_release(struct inode *unused, struct file *file)
 	return 0;
 }
 
+static int cs_char_release(struct inode *unused, struct file *file)
+{
+	struct cs_char *csdata = file->private_data;
+
+	return __cs_char_release(csdata);
+}
+
 static const struct file_operations cs_char_fops = {
 	.owner		= THIS_MODULE,
 	.read		= cs_char_read,
@@ -1363,6 +1398,112 @@ static struct miscdevice cs_char_miscdev = {
 	.fops	= &cs_char_fops
 };
 
+static struct snd_pcm_hardware my_pcm_hw = {
+	.info = (SNDRV_PCM_INFO_MMAP |
+		 SNDRV_PCM_INFO_INTERLEAVED |
+		 SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		 SNDRV_PCM_INFO_MMAP_VALID),
+	.formats          = SNDRV_PCM_FMTBIT_U8,
+	.rates            = SNDRV_PCM_RATE_8000,
+	.rate_min         = 8000,
+	.rate_max         = 8000,
+	.channels_min     = 1,
+	.channels_max     = 1,
+	.buffer_bytes_max = (32 * 48),
+	.period_bytes_min = 48,
+	.period_bytes_max = 48,
+	.periods_min      = 1,
+	.periods_max      = 32,
+};
+#define MAX_BUFFER 1024
+
+static int my_pcm_open(struct snd_pcm_substream *ss)
+{
+	ss->runtime->hw = my_pcm_hw;
+	ss->private_data = &cs_char_data;
+
+	printk("my_pcm_open\n");
+
+	return 0;
+}
+
+static int my_pcm_close(struct snd_pcm_substream *ss)
+{
+	ss->private_data = NULL;
+
+	printk("my_pcm_close\n");	
+
+	return 0;
+}
+
+static int my_hw_params(struct snd_pcm_substream *ss,
+			struct snd_pcm_hw_params *hw_params)
+{
+	return snd_pcm_lib_malloc_pages(ss,
+					params_buffer_bytes(hw_params));
+}
+
+static int my_hw_free(struct snd_pcm_substream *ss)
+{
+	return snd_pcm_lib_free_pages(ss);
+}
+
+static int my_pcm_prepare(struct snd_pcm_substream *ss)
+{
+	return 0;
+}
+
+static int my_pcm_trigger(struct snd_pcm_substream *ss,
+			  int cmd)
+{
+	struct cs_char *my_dev = snd_pcm_substream_chip(ss);
+	int ret = 0;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		// Start the hardware capture
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+		// Stop the hardware capture
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static snd_pcm_uframes_t my_pcm_pointer(struct snd_pcm_substream *ss)
+{
+	struct cs_char *my_dev = snd_pcm_substream_chip(ss);
+
+//	return my_dev->hw_idx;
+	return 0;
+}
+
+static int my_pcm_copy(struct snd_pcm_substream *ss,
+		       int channel, snd_pcm_uframes_t pos,
+		       void __user *dst,
+		       snd_pcm_uframes_t count)
+{
+	struct cs_char *my_dev = snd_pcm_substream_chip(ss);
+
+	//return copy_to_user(dst, my_dev->buffer + pos, count);
+	return -EFAULT;
+}
+
+static struct snd_pcm_ops my_pcm_ops = {
+	.open      = my_pcm_open,
+	.close     = my_pcm_close,
+	.ioctl     = snd_pcm_lib_ioctl,
+	.hw_params = my_hw_params,
+	.hw_free   = my_hw_free,
+	.prepare   = my_pcm_prepare,
+	.trigger   = my_pcm_trigger,
+	.pointer   = my_pcm_pointer,
+	.copy      = my_pcm_copy,
+};
+
 static int cs_hsi_client_probe(struct device *dev)
 {
 	int err = 0;
@@ -1398,14 +1539,48 @@ static int cs_hsi_client_probe(struct device *dev)
 		dev_err(dev, "Failed to register: %d\n", err);
 
 	printk("Registering sound card\n");
-#if 0
+#if 1
 	{
 	struct snd_card *card;
 	int ret;
-	ret = snd_card_create(SNDRV_DEFAULT_IDX1, "Nokia HSI modem",
+	ret = snd_card_new(dev, SNDRV_DEFAULT_IDX1, "Nokia HSI modem",
 			      THIS_MODULE, 0, &card);
 	if (ret < 0)
 		return ret;
+
+	strcpy(card->driver, "cmt_speech");
+	strcpy(card->shortname, "HSI modem");
+	sprintf(card->longname, "Nokia HSI modem");
+	snd_card_set_dev(card, dev);
+
+	static struct snd_device_ops ops = { NULL };
+	ret = snd_device_new(card, SNDRV_DEV_LOWLEVEL, dev, &ops);
+	if (ret < 0)
+		return ret;
+
+	struct snd_pcm *pcm;
+	ret = snd_pcm_new(card, card->driver, 0, 0, 1,
+			  &pcm);
+	if (ret < 0)
+		return ret;
+
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE,
+			&my_pcm_ops);
+	pcm->private_data = dev;
+	pcm->info_flags = 0;
+	strcpy(pcm->name, card->shortname);
+
+	ret = snd_pcm_lib_preallocate_pages_for_all(pcm,
+						    SNDRV_DMA_TYPE_CONTINUOUS,
+						    snd_dma_continuous_data(GFP_KERNEL),
+						    MAX_BUFFER, MAX_BUFFER);
+	if (ret < 0)
+		return ret;
+	
+	if ((ret = snd_card_register(card)) < 0)
+		return ret;
+
+	cs_char_data.card = card;
 	}
 #endif
 
@@ -1417,6 +1592,8 @@ static int cs_hsi_client_remove(struct device *dev)
 	struct cs_hsi_iface *hi;
 
 	dev_dbg(dev, "hsi_client_remove\n");
+
+	snd_card_free(cs_char_data.card);
 	misc_deregister(&cs_char_miscdev);
 	spin_lock_bh(&cs_char_data.lock);
 	hi = cs_char_data.hi;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
