From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv2 0/2] N900 Modem Speech Support
Date: Wed, 4 Mar 2015 20:24:19 +0100
Message-ID: <20150304192419.GA8981@amd>
References: <1425343454-6551-1-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425343454-6551-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi!

> This patchset contains the missing speech data support for the
> Nokia N900 modem.
> 
> Userland access goes via /dev/cmt_speech. The API is implemented in
> libcmtspeechdata, which is used by ofono and the freesmartphone.org project.
> Apart from that the device is also used by the phone binaries distributed
> with Maemo. So while this is a new userland ABI for the mainline kernel it
> has been tested in the wild for some years.
> 
> Simple Testing of the API can be done by checking out libcmtspeechdata [0],
> building the test tool and executing it. The tool will loop back audio data
> received from the caller.
> 
> I have prepared a kernel branch for this patchset, which can be found at [1].
> 
> Changes since PATCHv1 [2]:
>  * Squash cmt-speech patches together
>  * cs_alloc_cmds(): GFP_ATOMIC -> GFP_KERNEL
>  * CS_SET_WAKELINE ioctl: Add sanity check

commit fd3492869b9387f7bd97821badb491e9c0be463f
Author: Pavel <pavel@ucw.cz>
Date:   Wed Mar 4 20:22:32 2015 +0100

Simple cleanups, improve consistency.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index a017292..9609766 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -115,6 +115,7 @@ struct cs_hsi_iface {
 	unsigned int			rx_ptr_boundary;
 	unsigned int			rx_offsets[CS_MAX_BUFFERS];
 	unsigned int			tx_offsets[CS_MAX_BUFFERS];
+
 	/* size of aligned memory blocks */
 	unsigned int			slot_size;
 	unsigned int			flags;
@@ -194,32 +195,27 @@ static void cs_notify_data(u32 message, int maxlength)
 	cs_notify(message, &cs_char_data.dataind_queue);
 
 	spin_lock(&cs_char_data.lock);
-	++cs_char_data.dataind_pending;
+	cs_char_data.dataind_pending++;
 	while (cs_char_data.dataind_pending > maxlength &&
 				!list_empty(&cs_char_data.dataind_queue)) {
 		dev_dbg(&cs_char_data.cl->device, "data notification "
 		"queue overrun (%u entries)\n", cs_char_data.dataind_pending);
 
 		cs_pop_entry(&cs_char_data.dataind_queue);
-		--cs_char_data.dataind_pending;
+		cs_char_data.dataind_pending--;
 	}
 	spin_unlock(&cs_char_data.lock);
 }
 
 static inline void cs_set_cmd(struct hsi_msg *msg, u32 cmd)
 {
-	u32 *data;
-
-	data = sg_virt(msg->sgt.sgl);
+	u32 *data = sg_virt(msg->sgt.sgl);
 	*data = cmd;
 }
 
 static inline u32 cs_get_cmd(struct hsi_msg *msg)
 {
-	u32 *data;
-
-	data = sg_virt(msg->sgt.sgl);
-
+	u32 *data = sg_virt(msg->sgt.sgl);
 	return *data;
 }
 
@@ -641,7 +637,7 @@ static void cs_hsi_peek_on_data_complete(struct hsi_msg *msg)
 		cs_hsi_data_read_error(hi, msg);
 }
 
-/**
+/*
  * Read/write transaction is ongoing. Returns false if in
  * SSI_CHANNEL_STATE_POLL state.
  */
@@ -651,7 +647,7 @@ static inline int cs_state_xfer_active(unsigned int state)
 		(state & SSI_CHANNEL_STATE_READING);
 }
 
-/**
+/*
  * No pending read/writes
  */
 static inline int cs_state_idle(unsigned int state)
@@ -1117,10 +1113,9 @@ static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
 
-	if (fasync_helper(fd, file, on, &csdata->async_queue) >= 0)
-		return 0;
-	else
+	if (fasync_helper(fd, file, on, &csdata->async_queue) < 0)
 		return -EIO;
+	return 0;
 }
 
 static unsigned int cs_char_poll(struct file *file, poll_table *wait)
@@ -1149,7 +1144,7 @@ static ssize_t cs_char_read(struct file *file, char __user *buf, size_t count,
 	if (count < sizeof(data))
 		return -EINVAL;
 
-	for ( ; ; ) {
+	for (;;) {
 		DEFINE_WAIT(wait);
 
 		spin_lock_bh(&csdata->lock);
@@ -1157,7 +1152,7 @@ static ssize_t cs_char_read(struct file *file, char __user *buf, size_t count,
 			data = cs_pop_entry(&csdata->chardev_queue);
 		} else if (!list_empty(&csdata->dataind_queue)) {
 			data = cs_pop_entry(&csdata->dataind_queue);
-			--csdata->dataind_pending;
+			csdata->dataind_pending--;
 
 		} else {
 			data = 0;
@@ -1239,8 +1234,8 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 
 		if (copy_to_user((void __user *)arg, &ifver, sizeof(ifver)))
 			r = -EFAULT;
-		break;
 	}
+		break;
 	case CS_CONFIG_BUFS: {
 		struct cs_buffer_config buf_cfg;
 
@@ -1249,8 +1244,8 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 			r = -EFAULT;
 		else
 			r = cs_hsi_buf_config(csdata->hi, &buf_cfg);
-		break;
 	}
+		break;
 	default:
 		r = -ENOTTY;
 		break;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
