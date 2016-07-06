From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 11/12] evm: Translate user/group ids relative to s_user_ns when computing HMAC
Date: Wed,  6 Jul 2016 13:12:11 -0500
Message-ID: <20160706181212.16267-11-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160706181212.16267-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

The EVM HMAC should be calculated using the on disk user and
group ids, so the k[ug]ids in the inode must be translated
relative to the s_user_ns of the inode's super block.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
