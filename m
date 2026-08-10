Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C76A3F6C4D;
	Mon, 10 Aug 2026 14:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.218.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786371916; cv=none; b=aCPMuWRmA11//lAhMypj+aQfsha8Ql1ztmeteReGKjz0XE+NM9i28kUg6P8fEtGqEWnLOtHEmWAfO7Vd7pUhDg+Mg8q9Jbj6D9WYQhjkk0D0SSo1PsygMIuT+suO8malYW07UZjUaVgCdrJmwMRAFm/slonzoSuL4Bmz8tsfThk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786371916; c=relaxed/simple;
	bh=KR+pWenKxo5CxHxL1IKuA50lIDDXG6h5V7xGD1aCmzA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LzCMnaGNtxv9NeolbwBTp9Mrhh11rsGFmxOFFGACUe6qwCwldRSpm/yO2IglTqTd2F/2hk76SPR/GsGL5/SfJ0GCv8IvZcSK+Zu+cxvB0xGgO7/j1bjxluJufNdlaywyC4VMzt49bGukINNzEcJ5IHvwz3p1NilTc5+9lOfDnns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net; spf=pass smtp.mailfrom=laserology.net; dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b=jbwapdMZ; arc=none smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laserology.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b="jbwapdMZ"
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 87ABA46471B;
	Mon, 10 Aug 2026 14:25:12 +0000 (UTC)
Received: from de-fra-smtpout8.hostinger.io (trex-green-3.trex.outbound.svc.cluster.local [100.111.250.102])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id E930C4640E1;
	Mon, 10 Aug 2026 14:25:06 +0000 (UTC)
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: hostingeremail|x-authuser|admin@laserology.net
X-MailChannels-Auth-Id: hostingeremail
X-White-Soft: 1806f01276ca2cdb_1786371912174_999924832
X-MC-Loop-Signature: 1786371912174:2780800369
X-MC-Ingress-Time: 1786371912174
Received: from de-fra-smtpout8.hostinger.io (de-fra-smtpout8.hostinger.io
 [148.222.55.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.111.250.102 (trex/8.0.2);
	Mon, 10 Aug 2026 14:25:12 +0000
Received: from toolbx (unknown [IPv6:2605:59c0:2068:2608:c60b:fd48:4dc7:1cbd])
	(Authenticated sender: admin@laserology.net)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4hJcTq5Nndz3wln;
	Mon, 10 Aug 2026 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=laserology.net;
	s=hostingermail-a; t=1786371905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E1SVwe8xnFM6FaIiek70A9mOa0MBzgMVPnIL324XL9s=;
	b=jbwapdMZbWbdtt2mA3WfwUjMhqupY4v/Lj8UJxPxPtFdpteW0knp9ZGitpxBGVpxkEGKav
	L3p4g/yDGy4j+PGdjBxStdV1bDJeveExuYEYqPTND5CABawD8acF5olYha+6MI5ZjC/Mrb
	hvgzBqM6bopDKmlkAyOBEoVueySJQPHDuwBOdzipm7v9V31G/DrMv3HhcnYfNR0sj+o6kN
	bB7VljQCnDg6SEuvU8DzWhttcI2D7NwFtQEAa/C4UAh5b2kyrbeG58kQFqFIEFsUGmfL4p
	tHqYaxFTLAX6vWdk7E5KSP3YAd82dwg4AExrZaeKxpKKz3x8ekdbMKTetvGEDA==
From: Evan Lawrence <development@laserology.net>
To: linux-input@vger.kernel.org
Cc: linux-api@vger.kernel.org,
	dmitry.torokhov@gmail.com,
	miroslav.bendik@gmail.com,
	Evan Lawrence <development@laserology.net>
Subject: [PATCH v5] Input: synaptics - add pass-through mode for TrackPoint
Message-ID: <20260810142440.9060-1-development@laserology.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 10 Aug 2026 14:25:03 +0000 (UTC)
X-CM-Envelope: MS4xfJKYPGHLFpDVjEeTEnCZ6Ax63rdEsdfiGVjLkVtK69pyz6CM3VjqzaF59MbeQ429MfYkRFhDVxFG/yEl5pvY62Rz1Yl3kxXIYiKqQ088qUCQQQCMQG8K 8rIcA8CFMXmCOL3EP5ylsxWoJcTIm+ZLakVkLDHKshTbJVyPiWb/9Dq9LaZ6iEOXdWW1xYsix5nkYfC4HJzS+ceZl4/1f61jLJrr+kS/SpO2vXELoQxb6nkM FRmXgs5c83f/B3lpFrIT9E/k3rnikuMJlkEE6rkfP72PGPSe83D+0oarsau7ueluh82zwoQC7k9FxazpcRhtPPybvS6ZTkLrBxO+MeAdUAsXWdlid4JvyVCX /TQdM+Wsetu47K7561jx8ENu7Zf9IDluJWLNemh1pv28dTzTuqhvliwWLhKUTgtYGIF4xfEd
X-CM-Analysis: v=2.4 cv=etGNzZpX c=1 sm=1 tr=0 ts=6a79df41 a=bXe6bw2OB92olpQ1pPvang==:617 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=dBzw8yLgAAAA:8 a=k4TPoZDMbvFKk303EmMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=VaCLXHRpAd277H8a9-af:22
X-Hostinger-Verdict: junk
X-AuthUser: admin@laserology.net

Synaptics touchpads with a pass-through port (PS/2 guest) default to
encapsulating guest data in the touchpad's own packets, limiting the
guest device (typically a TrackPoint) to the touchpad's low poll rate.
Enabling transparent pass-through mode tells the touchpad to stop
generating its own packets and relay the raw byte stream from the guest
directly, letting the TrackPoint run at its full native speed while the
touchpad is effectively disabled.

This reworks an earlier implementation by Miroslav Bendík from 2022
that was never merged. It keeps the same hardware-mode approach but
commits the mode flag only after a successful mode command, moves the
reconnect handling into a generic psmouse hook instead of protocol-
specific checks in psmouse-interrupt, and documents the interface.

The mode is exposed via a sysfs transparent_mode attribute that allows
userspace to switch between full-rate TrackPoint and full-rate touchpad
operation at runtime.

If the system warm-boots while transparent mode is active the touchpad
stays in that mode and does not acknowledge command bytes, so
ps2_command() hangs and the device fails to be detected.  Escape
transparent mode by writing SETSCALE21 + SETSCALE11 directly to the wire
with serio_write() before attempting a reset or probe, both during
initial detection and on reconnect.

Link: https://lore.kernel.org/all/6932d599-2625-0376-d9c6-58cbb8879ff4@gmail.com/
Suggested-by: Miroslav Bendík <miroslav.bendik@gmail.com>
Assisted-by: DeepSeek:deepseek-v4-flash,deepseek-v4-pro
Signed-off-by: Evan Lawrence <development@laserology.net>
---

Notes:
    Changes in v2 (addressing review feedback):
    - Only consult the parent serio in psmouse_receive_byte() when it is a
      genuine psmouse pass-through port; a psmouse attached to a ps2mult
      child port has a parent whose drvdata is not a struct psmouse, so the
      unconditional cast could read a bogus function pointer.
    - Guard the guest state reset in synaptics_set_transparent_mode() on the
      pass-through port actually being bound to a psmouse, and commit the
      protocol handler/pktsize update with RX paused to avoid a torn update.
    - Exit transparent mode on the hardware as well as in software when the
      pass-through guest port is removed while the mode is active.
    - Re-run the full initialization (query, identity check, mode setup)
      before re-entering transparent mode during reconnect, so the device is
      in a known configuration after a reset.
    - Use psmouse_set_state(PSMOUSE_ACTIVATED) to drop stale guest data
      instead of the bare pktcnt = 0 assignment, which could leave the
      psmouse state machine (flags, state) out of sync with the packet
      counter.
    - Move the dev-attr creation ahead of the pass-through port registration
      so that an attribute creation failure cannot leak a registered child
      port whose callbacks reference freed synaptics_data.
    
    Changes in v3 (addressing review feedback):
    - Scope the serio_pause_rx guard in synaptics_set_transparent_mode() to
      the protocol-handler commit only; calling psmouse_set_state() inside
      it re-enables interrupts via serio_continue_rx() while the parent lock
      is held, which can deadlock.
    - In synaptics_pt_stop(), exit hardware transparent mode before updating
      the software protocol handler, so guest data is never misparsed as
      host touchpad packets.
    
    Changes in v4 (addressing review feedback):
    - Drop the pt_psmouse field and the child-state reset in
      synaptics_set_transparent_mode(): storing drvdata as a psmouse pointer
      without verifying the driver type creates a type-confusion risk.
      The PS/2 psmouse handler already resynchronizes after stale bytes,
      so dropping the explicit reset is safe.
    - Remove the pass-through serio unregistration from
      synaptics_disconnect(): calling serio_unregister_port() from inside
      the parent disconnect callback deadlocks on serio_mutex, and the
      child port is already destroyed by serio_disconnect_port() before
      the parent disconnect runs, making the call a use-after-free.
    - Guard the two-command write sequence in synaptics_pt_write() with a
      per-device mutex and hold it across both the transparent fast-path
      and the hardware mode-switch commands in
      synaptics_set_transparent_mode(), so a concurrent pt_write cannot
      inject a byte onto the PS/2 bus mid-command and corrupt the
      passthrough transaction.
    - Add defensive id.type == SERIO_PS_PSTHRU checks before the
      psmouse_from_serio() casts in synaptics_pass_pt_packet() and
      synaptics_pt_activate().
    - Issue SETSCALE21/SETSCALE11 commands after the initial reset in
      __synaptics_init() so that a touchpad left in transparent mode from
      a previous session can still be detected and initialized after a
      warm reboot.
    - Skip the BAT (0xAA) detection in psmouse_receive_byte() while
      transparent mode is active, via a pt_bypass_bat flag on struct
      psmouse.  Every byte on the parent serio belongs to the
      pass-through guest; a TrackPoint can legitimately send 0xAA 0x00
      as motion data, and consuming the 0xAA byte would silently drop it
      before it reaches the guest handler.
    - Clear pt_bypass_bat in synaptics_pt_stop() when the guest port is
      removed so that BAT detection resumes for the touchpad itself.
    
    Changes in v5 (addressing review feedback):
    - In synaptics_pt_stop(), sample the transparent_mode flag inside the
      pt_mutex guard instead of before it.  A concurrent
      synaptics_set_transparent_mode() could otherwise change the flag
      between the snapshot and the lock acquire, causing the function to
      either skip hardware exit when it should not, or double-exit on an
      already-disabled device.
    - In synaptics_set_transparent_mode(), check pt_port for NULL inside
      the pt_mutex guard rather than before it, so a concurrent
      synaptics_pt_stop() cannot clear pt_port after the check and before
      the mode-switch commands are sent.
    - In synaptics_set_rate(), bail out early when transparent mode is
      active.  The set_rate callback sends a mode command via
      synaptics_mode_cmd() without holding pt_mutex, while
      synaptics_pt_write() in transparent fast-path mode holds pt_mutex
      but bypasses ps2_cmd_mutex, so the two byte streams can interleave
      on the PS/2 bus and corrupt the command.
    - In synaptics_reconnect(), hold pt_mutex across the
      synaptics_enter_transparent_mode() call that re-enters the mode
      after resume, and re-read pt_port inside the mutex, saving it to a
      local variable so that the subsequent serio_reconnect() uses a
      consistent pointer.
    - Use READ_ONCE() when reading pt_port and pt_port_open in interrupt
      and serio callback contexts to prevent loads from being torn or
      reordered across the pt_mutex boundary.
    - Move the serio_reconnect() call in synaptics_reconnect() inside the
      pt_mutex guard so that pt_port remains valid for its duration.
    - After a warm reboot while transparent mode is active the touchpad
      does not acknowledge command bytes, so ps2_command() hangs and the
      device is not detected.  Escape transparent mode by writing
      SETSCALE21 + SETSCALE11 directly to the wire with serio_write()
      before attempting a reset or probe, both during initial detection
      and on reconnect.

 .../ABI/testing/sysfs-driver-synaptics        |  28 ++
 MAINTAINERS                                   |   1 +
 drivers/input/mouse/psmouse-base.c            |  20 +-
 drivers/input/mouse/psmouse.h                 |  15 +
 drivers/input/mouse/synaptics.c               | 373 +++++++++++++++++-
 drivers/input/mouse/synaptics.h               |   6 +
 6 files changed, 420 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-synaptics

diff --git a/Documentation/ABI/testing/sysfs-driver-synaptics b/Documentation/ABI/testing/sysfs-driver-synaptics
new file mode 100644
index 000000000000..bec715677e3e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-synaptics
@@ -0,0 +1,28 @@
+What:		/sys/bus/serio/devices/serioX/transparent_mode
+Date:		August 2026
+Contact:	linux-input@vger.kernel.org
+Description:
+		Controls the transparent pass-through mode of Synaptics
+		touchpads that feature a pass-through (PS/2 guest) port, such as
+		those used for a TrackPoint.
+
+		In normal operation the touchpad serves as the PS/2 host for
+		the pass-through guest: it scans the guest during its own scan
+		cycle and encapsulates the guest's data into its own packets,
+		which limits the guest to the touchpad's low poll rate. When
+		transparent mode is enabled the touchpad stops generating its
+		own packets and simply relays the raw byte stream of the
+		pass-through guest, letting the guest run at its high poll rate
+		while the touchpad is effectively disabled.
+
+		Write 1 to enable the mode, or 0 to disable it. Reading the
+		attribute returns the current state ("0" or "1").
+
+		Note that both devices cannot be serviced at full rate at the
+		same time on this hardware; enabling the mode disables the
+		touchpad until it is disabled again. The attribute is present
+		only on devices that report the pass-through capability.
+
+Users:		Userspace that arbitrates between full-rate TrackPoint and
+		full-rate touchpad operation. No consumer exists yet; the
+		interface is provided so that one can be developed.
diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..312c13690c91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12817,6 +12817,7 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 Q:	http://patchwork.kernel.org/project/linux-input/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
+F:	Documentation/ABI/testing/sysfs-driver-synaptics
 F:	Documentation/devicetree/bindings/input/
 F:	Documentation/devicetree/bindings/serio/
 F:	Documentation/input/
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 6ab5f1d96eae..b1be88899e65 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -378,15 +378,31 @@ static void psmouse_receive_byte(struct ps2dev *ps2dev, u8 data)
 	psmouse->packet[psmouse->pktcnt++] = data;
 
 	/* Check if this is a new device announcement (0xAA 0x00) */
-	if (unlikely(psmouse->packet[0] == PSMOUSE_RET_BAT && psmouse->pktcnt <= 2)) {
+	if (unlikely(!READ_ONCE(psmouse->pt_bypass_bat) &&
+		     psmouse->packet[0] == PSMOUSE_RET_BAT && psmouse->pktcnt <= 2)) {
 		if (psmouse->pktcnt == 1) {
 			psmouse->last = jiffies;
 			return;
 		}
 
 		if (psmouse->packet[1] == PSMOUSE_RET_ID) {
+			struct serio *serio = ps2dev->serio;
+			struct psmouse *parent_psmouse = NULL;
+
 			__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
-			serio_reconnect(ps2dev->serio);
+			/*
+			 * Some devices need parent to be reconnected instead.
+			 * Only consult the parent if this is a genuine psmouse
+			 * pass-through port; other serio children may have a
+			 * parent whose drvdata is not a struct psmouse.
+			 */
+			if (serio->parent && serio->id.type == SERIO_PS_PSTHRU)
+				parent_psmouse = psmouse_from_serio(serio->parent);
+			if (parent_psmouse && parent_psmouse->pt_reconnect_parent &&
+			    parent_psmouse->pt_reconnect_parent(parent_psmouse))
+				serio_reconnect(serio->parent);
+			else
+				serio_reconnect(serio);
 			return;
 		}
 
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 90ed8cd15d85..9391002fedc9 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -128,6 +128,21 @@ struct psmouse {
 
 	void (*pt_activate)(struct psmouse *psmouse);
 	void (*pt_deactivate)(struct psmouse *psmouse);
+
+	/*
+	 * Called on the parent device when a pass-through guest reports a new
+	 * device announcement (0xAA 0x00). Return true if the parent, and not
+	 * the guest, should be reconnected.
+	 */
+	bool (*pt_reconnect_parent)(struct psmouse *psmouse);
+
+	/*
+	 * When true the parent is in transparent mode and the standard
+	 * BAT (0xAA) detection in psmouse_receive_byte must be skipped:
+	 * every byte arriving on the parent serio belongs to the
+	 * pass-through guest and is not a device announcement.
+	 */
+	bool pt_bypass_bat;
 };
 
 struct psmouse *psmouse_from_serio(struct serio *serio);
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index c70502e24031..aaf66b73bcfe 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -98,6 +98,17 @@ int synaptics_detect(struct psmouse *psmouse, bool set_properties)
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	u8 param[4] = { 0 };
 
+	/*
+	 * If the device was left in transparent mode after a warm
+	 * reboot it will not acknowledge any command byte.  Exit
+	 * the mode first with serio_write(), which places the
+	 * escape sequence directly on the wire without waiting
+	 * for an acknowledgement.
+	 */
+	serio_write(ps2dev->serio, PSMOUSE_CMD_SETSCALE21);
+	serio_write(ps2dev->serio, PSMOUSE_CMD_SETSCALE11);
+	mdelay(5);
+
 	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
 	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
 	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
@@ -622,6 +633,9 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
 {
 	struct synaptics_data *priv = psmouse->private;
 
+	if (READ_ONCE(priv->transparent_mode))
+		return;
+
 	if (rate >= 80) {
 		priv->mode |= SYN_BIT_HIGH_RATE;
 		psmouse->rate = 80;
@@ -636,12 +650,90 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
 /*****************************************************************************
  *	Synaptics pass-through PS/2 port support
  ****************************************************************************/
+static psmouse_ret_t synaptics_process_byte(struct psmouse *psmouse);
+
+static psmouse_ret_t transparent_process_byte(struct psmouse *psmouse)
+{
+	struct synaptics_data *priv = psmouse->private;
+	struct serio *pt_port = READ_ONCE(priv->pt_port);
+
+	if (!pt_port)
+		return PSMOUSE_BAD_DATA;
+
+	serio_interrupt(pt_port, psmouse->packet[psmouse->pktcnt - 1], 0);
+	return PSMOUSE_FULL_PACKET;
+}
+
+static void synaptics_update_protocol_handler(struct psmouse *psmouse)
+{
+	struct synaptics_data *priv = psmouse->private;
+	struct serio *pt_port = READ_ONCE(priv->pt_port);
+	bool absolute_mode = priv->absolute_mode;
+	bool transparent_mode = READ_ONCE(priv->transparent_mode);
+
+	if (transparent_mode && pt_port) {
+		psmouse->protocol_handler = transparent_process_byte;
+	} else {
+		if (absolute_mode) {
+			psmouse->protocol_handler = synaptics_process_byte;
+			psmouse->pktsize = 6;
+		} else {
+			/* Relative mode follows standard PS/2 mouse protocol */
+			psmouse->protocol_handler = psmouse_process_byte;
+			psmouse->pktsize = 3;
+		}
+	}
+}
+
+static int synaptics_enter_transparent_mode(struct psmouse *psmouse)
+{
+	struct synaptics_data *priv = psmouse->private;
+	int error;
+
+	error = synaptics_mode_cmd(psmouse, priv->mode | SYN_BIT_TRANSPARENT_MODE);
+	if (error)
+		return error;
+
+	priv->mode |= SYN_BIT_TRANSPARENT_MODE;
+
+	return 0;
+}
+
+static int synaptics_exit_transparent_mode(struct psmouse *psmouse)
+{
+	struct synaptics_data *priv = psmouse->private;
+	int error;
+
+	/* Send scaling 2:1, 1:1 to exit transparent mode */
+	error = ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
+	if (error)
+		return error;
+	error = ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
+	if (error)
+		return error;
+
+	/* Re-enter the regular operating mode of the touchpad */
+	error = synaptics_mode_cmd(psmouse, priv->mode & ~SYN_BIT_TRANSPARENT_MODE);
+	if (error)
+		return error;
+
+	priv->mode &= ~SYN_BIT_TRANSPARENT_MODE;
+
+	return 0;
+}
+
 static int synaptics_pt_write(struct serio *serio, u8 c)
 {
 	struct psmouse *parent = psmouse_from_serio(serio->parent);
+	struct synaptics_data *priv = parent->private;
 	u8 rate_param = SYN_PS_CLIENT_CMD; /* indicates that we want pass-through port */
 	int error;
 
+	guard(mutex)(&priv->pt_mutex);
+
+	if (READ_ONCE(priv->transparent_mode))
+		return parent->ps2dev.serio->write(parent->ps2dev.serio, c);
+
 	error = ps2_sliced_command(&parent->ps2dev, c);
 	if (error)
 		return error;
@@ -661,6 +753,8 @@ static int synaptics_pt_start(struct serio *serio)
 	guard(serio_pause_rx)(parent->ps2dev.serio);
 	priv->pt_port = serio;
 
+	synaptics_update_protocol_handler(parent);
+
 	return 0;
 }
 
@@ -669,8 +763,28 @@ static void synaptics_pt_stop(struct serio *serio)
 	struct psmouse *parent = psmouse_from_serio(serio->parent);
 	struct synaptics_data *priv = parent->private;
 
-	guard(serio_pause_rx)(parent->ps2dev.serio);
-	priv->pt_port = NULL;
+	/*
+	 * The guest is going away. Hold the pass-through mutex across
+	 * the hardware exit and the software state update so a
+	 * concurrent synaptics_pt_write() cannot observe the old
+	 * transparent_mode after the hardware has already been
+	 * switched back to normal operation.
+	 */
+	guard(mutex)(&priv->pt_mutex);
+
+	if (READ_ONCE(priv->transparent_mode)) {
+		if (synaptics_exit_transparent_mode(parent))
+			psmouse_warn(parent,
+				     "failed to exit transparent mode after pass-through port removal\n");
+	}
+
+	{
+		guard(serio_pause_rx)(parent->ps2dev.serio);
+		priv->pt_port = NULL;
+		WRITE_ONCE(priv->transparent_mode, false);
+		WRITE_ONCE(parent->pt_bypass_bat, false);
+		synaptics_update_protocol_handler(parent);
+	}
 }
 
 static int synaptics_pt_open(struct serio *serio)
@@ -681,6 +795,19 @@ static int synaptics_pt_open(struct serio *serio)
 	guard(serio_pause_rx)(parent->ps2dev.serio);
 	priv->pt_port_open = true;
 
+	/*
+	 * In transparent mode every byte on the parent serio belongs to
+	 * the pass-through guest and is not a BAT announcement.  Skip
+	 * BAT detection on the child as well so that guest motion data
+	 * that happens to look like 0xAA 0x00 does not trigger a
+	 * spurious parent reconnect.
+	 */
+	if (READ_ONCE(priv->transparent_mode) &&
+	    serio->id.type == SERIO_PS_PSTHRU) {
+		struct psmouse *child = psmouse_from_serio(serio);
+		WRITE_ONCE(child->pt_bypass_bat, true);
+	}
+
 	return 0;
 }
 
@@ -691,6 +818,24 @@ static void synaptics_pt_close(struct serio *serio)
 
 	guard(serio_pause_rx)(parent->ps2dev.serio);
 	priv->pt_port_open = false;
+
+	/* Restore BAT detection when the port is closed */
+	if (serio->id.type == SERIO_PS_PSTHRU) {
+		struct psmouse *child = psmouse_from_serio(serio);
+		WRITE_ONCE(child->pt_bypass_bat, false);
+	}
+}
+
+/*
+ * When the touchpad is in transparent mode resetting the guest alone is not
+ * enough, the host needs to be reconnected so that transparent mode is
+ * re-established.
+ */
+static bool synaptics_pt_reconnect_parent(struct psmouse *psmouse)
+{
+	struct synaptics_data *priv = psmouse->private;
+
+	return READ_ONCE(priv->transparent_mode);
 }
 
 static int synaptics_is_pt_packet(u8 *buf)
@@ -702,13 +847,13 @@ static void synaptics_pass_pt_packet(struct synaptics_data *priv, u8 *packet)
 {
 	struct serio *ptport;
 
-	ptport = priv->pt_port;
+	ptport = READ_ONCE(priv->pt_port);
 	if (!ptport)
 		return;
 
 	serio_interrupt(ptport, packet[1], 0);
 
-	if (priv->pt_port_open) {
+	if (READ_ONCE(priv->pt_port_open) && ptport->id.type == SERIO_PS_PSTHRU) {
 		struct psmouse *child = psmouse_from_serio(ptport);
 
 		if (child->state == PSMOUSE_ACTIVATED) {
@@ -723,7 +868,15 @@ static void synaptics_pass_pt_packet(struct synaptics_data *priv, u8 *packet)
 static void synaptics_pt_activate(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
-	struct psmouse *child = psmouse_from_serio(priv->pt_port);
+	struct psmouse *child = NULL;
+	struct serio *pt_port = READ_ONCE(priv->pt_port);
+
+	if (pt_port && pt_port->id.type == SERIO_PS_PSTHRU)
+		child = psmouse_from_serio(pt_port);
+
+	/* no mode change needed when transparent mode is active */
+	if (READ_ONCE(priv->transparent_mode))
+		return;
 
 	/* adjust the touchpad to child's choice of protocol */
 	if (child) {
@@ -760,6 +913,7 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 	serio->parent = psmouse->ps2dev.serio;
 
 	psmouse->pt_activate = synaptics_pt_activate;
+	psmouse->pt_reconnect_parent = synaptics_pt_reconnect_parent;
 
 	psmouse_info(psmouse, "serio: %s port at %s\n",
 		     serio->name, psmouse->phys);
@@ -987,17 +1141,21 @@ static void synaptics_report_ext_buttons(struct psmouse *psmouse,
 	 * physically wired to the touchpad. Re-route them through
 	 * the pass-through interface.
 	 */
-	if (priv->pt_port) {
+	{
+		struct serio *pt_port = READ_ONCE(priv->pt_port);
 		u8 pt_buttons;
 
+		if (!pt_port)
+			return;
+
 		/* The trackstick expects at most 3 buttons */
 		pt_buttons = SYN_EXT_BUTTON_STICK_L(hw->ext_buttons)      |
 			     SYN_EXT_BUTTON_STICK_R(hw->ext_buttons) << 1 |
 			     SYN_EXT_BUTTON_STICK_M(hw->ext_buttons) << 2;
 
-		serio_interrupt(priv->pt_port,
+		serio_interrupt(pt_port,
 				PSMOUSE_OOB_EXTRA_BTNS, SERIO_OOB_DATA);
-		serio_interrupt(priv->pt_port, pt_buttons, SERIO_OOB_DATA);
+		serio_interrupt(pt_port, pt_buttons, SERIO_OOB_DATA);
 	}
 }
 
@@ -1437,6 +1595,93 @@ PSMOUSE_DEFINE_ATTR(disable_gesture, S_IWUSR | S_IRUGO, NULL,
 		    synaptics_show_disable_gesture,
 		    synaptics_set_disable_gesture);
 
+static ssize_t synaptics_show_transparent_mode(struct psmouse *psmouse,
+					       void *data, char *buf)
+{
+	struct synaptics_data *priv = psmouse->private;
+
+	return sysfs_emit(buf, "%c\n",
+			  READ_ONCE(priv->transparent_mode) ? '1' : '0');
+}
+
+static ssize_t synaptics_set_transparent_mode(struct psmouse *psmouse,
+					      void *data, const char *buf,
+					      size_t len)
+{
+	struct synaptics_data *priv = psmouse->private;
+	unsigned int value;
+	int err;
+
+	err = kstrtouint(buf, 10, &value);
+	if (err)
+		return err;
+
+	if (value > 1)
+		return -EINVAL;
+
+	if (value == READ_ONCE(priv->transparent_mode))
+		return len;
+
+	/*
+	 * Switch the hardware first and only commit the new mode and protocol
+	 * handler once it succeeded, so a failing command cannot leave the
+	 * driver with bookkeeping that does not match the device. The touchpad
+	 * is deactivated for the duration of this write (see
+	 * psmouse_attr_set_helper), so no live data can be misparsed in
+	 * between.  Hold the pass-through mutex so that a concurrent
+	 * synaptics_pt_write() cannot inject a byte onto the bus in the
+	 * middle of the mode-switch command sequence.
+	 */
+	guard(mutex)(&priv->pt_mutex);
+
+	/* Transparent mode only makes sense while the guest is attached */
+	if (value && !READ_ONCE(priv->pt_port))
+		return -ENODEV;
+
+	if (value) {
+		err = synaptics_enter_transparent_mode(psmouse);
+		if (err)
+			return err;
+	} else {
+		err = synaptics_exit_transparent_mode(psmouse);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Commit the software state with RX paused so the interrupt handler
+	 * never observes a torn (protocol_handler, pktsize) pair while the
+	 * pass-through guest keeps streaming.
+	 */
+	{
+		guard(serio_pause_rx)(psmouse->ps2dev.serio);
+		WRITE_ONCE(priv->transparent_mode, value);
+		synaptics_update_protocol_handler(psmouse);
+		WRITE_ONCE(psmouse->pt_bypass_bat, value);
+
+		/*
+		 * Mirror the BAT-bypass flag on the child so that
+		 * guest motion data resembling a reset announcement
+		 * (0xAA 0x00) does not trigger a spurious parent
+		 * reconnect through the child's bat-detection path.
+		 */
+		{
+			struct serio *pt_port = READ_ONCE(priv->pt_port);
+
+			if (pt_port && pt_port->id.type == SERIO_PS_PSTHRU) {
+				struct psmouse *child = psmouse_from_serio(pt_port);
+				WRITE_ONCE(child->pt_bypass_bat, value);
+			}
+		}
+	}
+
+	return len;
+}
+
+PSMOUSE_DEFINE_ATTR(transparent_mode, 0644, NULL,
+		    synaptics_show_transparent_mode,
+		    synaptics_set_transparent_mode);
+
 static void synaptics_disconnect(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
@@ -1447,10 +1692,20 @@ static void synaptics_disconnect(struct psmouse *psmouse)
 	 */
 	psmouse_smbus_cleanup(psmouse);
 
+	if (READ_ONCE(priv->transparent_mode)) {
+		guard(mutex)(&priv->pt_mutex);
+		synaptics_exit_transparent_mode(psmouse);
+		WRITE_ONCE(priv->transparent_mode, false);
+		WRITE_ONCE(psmouse->pt_bypass_bat, false);
+	}
+
 	if (!priv->absolute_mode &&
 			SYN_ID_DISGEST_SUPPORTED(priv->info.identity))
 		device_remove_file(&psmouse->ps2dev.serio->dev,
 				   &psmouse_attr_disable_gesture.dattr);
+	if (SYN_CAP_PASS_THROUGH(priv->info.capabilities))
+		device_remove_file(&psmouse->ps2dev.serio->dev,
+				   &psmouse_attr_transparent_mode.dattr);
 
 	synaptics_reset(psmouse);
 	kfree(priv);
@@ -1465,6 +1720,16 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 	int retry = 0;
 	int error;
 
+	/*
+	 * If the touchpad is in transparent mode it will not ACK
+	 * any command byte, so we place the escape sequence directly
+	 * on the wire with serio_write() before attempting a reset
+	 * or a probe.
+	 */
+	serio_write(psmouse->ps2dev.serio, PSMOUSE_CMD_SETSCALE21);
+	serio_write(psmouse->ps2dev.serio, PSMOUSE_CMD_SETSCALE11);
+	mdelay(5);
+
 	do {
 		psmouse_reset(psmouse);
 		if (retry) {
@@ -1477,8 +1742,42 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 			 */
 			ssleep(1);
 		}
-		ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETID);
-		error = synaptics_detect(psmouse, 0);
+		if (READ_ONCE(priv->transparent_mode) && READ_ONCE(priv->pt_port)) {
+			struct serio *pt_port;
+			/*
+			 * psmouse_reset() above put the touchpad back into its
+			 * power-on state, so run the full initialization before
+			 * re-entering transparent mode. Otherwise the device
+			 * would come back missing the configuration set up by
+			 * synaptics_set_mode() (e.g. Advanced Gesture Mode) and
+			 * would stay uninitialized once transparent mode is
+			 * disabled again.
+			 */
+			error = synaptics_query_hardware(psmouse, &info);
+			if (!error &&
+			    (info.identity != priv->info.identity ||
+			     info.model_id != priv->info.model_id ||
+			     info.capabilities != priv->info.capabilities ||
+			     info.ext_cap != priv->info.ext_cap))
+				error = -ENXIO;
+			if (!error)
+				error = synaptics_set_mode(psmouse);
+			if (!error) {
+				guard(mutex)(&priv->pt_mutex);
+				pt_port = READ_ONCE(priv->pt_port);
+				if (pt_port)
+					error = synaptics_enter_transparent_mode(psmouse);
+				else
+					error = -ENODEV;
+				if (!error) {
+					serio_reconnect(pt_port);
+					return 0;
+				}
+			}
+		} else {
+			ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETID);
+			error = synaptics_detect(psmouse, 0);
+		}
 	} while (error && ++retry < 3);
 
 	if (error)
@@ -1602,6 +1901,8 @@ static int synaptics_init_ps2(struct psmouse *psmouse,
 	if (!priv)
 		return -ENOMEM;
 
+	mutex_init(&priv->pt_mutex);
+
 	priv->info = *info;
 	priv->absolute_mode = absolute_mode;
 	if (SYN_ID_DISGEST_SUPPORTED(info->identity))
@@ -1647,14 +1948,7 @@ static int synaptics_init_ps2(struct psmouse *psmouse,
 	psmouse->model = ((info->model_id & 0x00ff0000) >> 8) |
 			  (info->model_id & 0x000000ff);
 
-	if (absolute_mode) {
-		psmouse->protocol_handler = synaptics_process_byte;
-		psmouse->pktsize = 6;
-	} else {
-		/* Relative mode follows standard PS/2 mouse protocol */
-		psmouse->protocol_handler = psmouse_process_byte;
-		psmouse->pktsize = 3;
-	}
+	synaptics_update_protocol_handler(psmouse);
 
 	psmouse->set_rate = synaptics_set_rate;
 	psmouse->disconnect = synaptics_disconnect;
@@ -1664,9 +1958,6 @@ static int synaptics_init_ps2(struct psmouse *psmouse,
 	/* Synaptics can usually stay in sync without extra help */
 	psmouse->resync_time = 0;
 
-	if (SYN_CAP_PASS_THROUGH(info->capabilities))
-		synaptics_pt_create(psmouse);
-
 	/*
 	 * Toshiba's KBC seems to have trouble handling data from
 	 * Synaptics at full rate.  Switch to a lower rate (roughly
@@ -1690,9 +1981,35 @@ static int synaptics_init_ps2(struct psmouse *psmouse,
 		}
 	}
 
+	if (SYN_CAP_PASS_THROUGH(info->capabilities)) {
+		err = device_create_file(&psmouse->ps2dev.serio->dev,
+					 &psmouse_attr_transparent_mode.dattr);
+		if (err) {
+			psmouse_err(psmouse,
+				    "Failed to create transparent_mode attribute (%d)",
+				    err);
+			goto init_fail;
+		}
+	}
+
+	/*
+	 * Register the pass-through port only once all initialization steps
+	 * that can fail have succeeded, so that a failure in one of the steps
+	 * above cannot leak a registered child port whose callbacks would
+	 * dereference the freed synaptics_data.
+	 */
+	if (SYN_CAP_PASS_THROUGH(info->capabilities))
+		synaptics_pt_create(psmouse);
+
 	return 0;
 
  init_fail:
+	if (!priv->absolute_mode && SYN_ID_DISGEST_SUPPORTED(priv->info.identity))
+		device_remove_file(&psmouse->ps2dev.serio->dev,
+				   &psmouse_attr_disable_gesture.dattr);
+	if (SYN_CAP_PASS_THROUGH(priv->info.capabilities))
+		device_remove_file(&psmouse->ps2dev.serio->dev,
+				   &psmouse_attr_transparent_mode.dattr);
 	kfree(priv);
 	return err;
 }
@@ -1702,6 +2019,20 @@ static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
 	struct synaptics_device_info info;
 	int error;
 
+	/*
+	 * After a warm reboot the touchpad may still be in transparent
+	 * mode, silently relaying the pass-through guest's byte stream
+	 * and responding to neither a reset nor the Synaptics probe
+	 * queries.  Exit transparent mode here, before the reset,
+	 * because once the touchpad enters this mode it never ACKs
+	 * a command byte.  serio_write() places the bytes directly on
+	 * the wire without waiting for an acknowledgement, so we can
+	 * reach the device even when it is deaf.
+	 */
+	serio_write(psmouse->ps2dev.serio, PSMOUSE_CMD_SETSCALE21);
+	serio_write(psmouse->ps2dev.serio, PSMOUSE_CMD_SETSCALE11);
+	mdelay(5);
+
 	psmouse_reset(psmouse);
 
 	error = synaptics_query_hardware(psmouse, &info);
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 3853165b6b3a..dc2031851cfd 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -6,6 +6,8 @@
 #ifndef _SYNAPTICS_H
 #define _SYNAPTICS_H
 
+#include <linux/mutex.h>
+
 /* synaptics queries */
 #define SYN_QUE_IDENTIFY		0x00
 #define SYN_QUE_MODES			0x01
@@ -24,6 +26,7 @@
 /* synaptics modes */
 #define SYN_BIT_ABSOLUTE_MODE		BIT(7)
 #define SYN_BIT_HIGH_RATE		BIT(6)
+#define SYN_BIT_TRANSPARENT_MODE	BIT(5)
 #define SYN_BIT_SLEEP_MODE		BIT(3)
 #define SYN_BIT_DISABLE_GESTURE		BIT(2)
 #define SYN_BIT_FOUR_BYTE_CLIENT	BIT(1)
@@ -186,10 +189,13 @@ struct synaptics_data {
 
 	bool absolute_mode;			/* run in Absolute mode */
 	bool disable_gesture;			/* disable gestures */
+	bool transparent_mode;			/* pass packets directly from guest */
 
 	struct serio *pt_port;			/* Pass-through serio port */
 	bool pt_port_open;
 
+	struct mutex pt_mutex;			/* Serializes pt_write commands */
+
 	/*
 	 * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
 	 * contains position data for a second contact, at half resolution.

base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
2.55.0

