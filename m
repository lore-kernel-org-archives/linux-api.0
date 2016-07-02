From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 10/11] evm: Translate user/group ids relative to s_user_ns when computing HMAC
Date: Sat,  2 Jul 2016 12:20:34 -0500
Message-ID: <20160702172035.19568-10-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160702172035.19568-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

The EVM HMAC should be calculated using the on disk user and
group ids, so the k[ug]ids in the inode must be translated
relative to the s_user_ns of the inode's super block.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/integrity/evm/evm_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 30b6b7d0429f..11c1d30bd705 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -151,8 +151,8 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 	memset(&hmac_misc, 0, sizeof(hmac_misc));
 	hmac_misc.ino = inode->i_ino;
 	hmac_misc.generation = inode->i_generation;
-	hmac_misc.uid = from_kuid(&init_user_ns, inode->i_uid);
-	hmac_misc.gid = from_kgid(&init_user_ns, inode->i_gid);
+	hmac_misc.uid = from_kuid(inode->i_sb->s_user_ns, inode->i_uid);
+	hmac_misc.gid = from_kgid(inode->i_sb->s_user_ns, inode->i_gid);
 	hmac_misc.mode = inode->i_mode;
 	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
 	if (evm_hmac_attrs & EVM_ATTR_FSUUID)
-- 
2.8.3

