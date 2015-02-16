From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 41/45] include/uapi/sound/emu10k1.h: hide gpr_valid, tram_valid and code_valid in userspace
Date: Tue, 17 Feb 2015 00:05:44 +0100
Message-ID: <1424127948-22484-42-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The DECLARE_BITMAP macro is not available in userspace headers.
=46ixes userspace compile error:
error: expected specifier-qualifier-list before =E2=80=98DECLARE_BITMAP=
=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/sound/emu10k1.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/sound/emu10k1.h b/include/uapi/sound/emu10k1.=
h
index ec1535b..f2fd870 100644
--- a/include/uapi/sound/emu10k1.h
+++ b/include/uapi/sound/emu10k1.h
@@ -300,7 +300,9 @@ struct snd_emu10k1_fx8010_control_old_gpr {
 struct snd_emu10k1_fx8010_code {
 	char name[128];
=20
+#ifdef __KERNEL__
 	DECLARE_BITMAP(gpr_valid, 0x200); /* bitmask of valid initializers */
+#endif
 	__u32 __user *gpr_map;		/* initializers */
=20
 	unsigned int gpr_add_control_count; /* count of GPR controls to add/r=
eplace */
@@ -313,11 +315,15 @@ struct snd_emu10k1_fx8010_code {
 	unsigned int gpr_list_control_total; /* total count of GPR controls *=
/
 	struct snd_emu10k1_fx8010_control_gpr __user *gpr_list_controls; /* l=
isted GPR controls */
=20
+#ifdef __KERNEL__
 	DECLARE_BITMAP(tram_valid, 0x100); /* bitmask of valid initializers *=
/
+#endif
 	__u32 __user *tram_data_map;	  /* data initializers */
 	__u32 __user *tram_addr_map;	  /* map initializers */
=20
+#ifdef __KERNEL__
 	DECLARE_BITMAP(code_valid, 1024); /* bitmask of valid instructions */
+#endif
 	__u32 __user *code;		  /* one instruction - 64 bits */
 };
=20
--=20
2.1.4
