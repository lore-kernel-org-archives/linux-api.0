From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 13/14] selinux: Implement the watch_key security hook
 [ver #2]
Date: Thu, 07 Nov 2019 13:37:20 +0000
Message-ID: <157313384065.29677.12354003434069581212.stgit@warthog.procyon.org.uk>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implement the watch_key security hook to make sure that a key grants the
caller View permission in order to set a watch on a key.

For the moment, the watch_devices security hook is left unimplemented as
it's not obvious what the object should be since the queue is global and
didn't previously exist.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
---

 security/selinux/hooks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9625b99e677f..53637dccee00 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6579,6 +6579,17 @@ static int selinux_key_getsecurity(struct key *key, =
char **_buffer)
 =09*_buffer =3D context;
 =09return rc;
 }
+
+#ifdef CONFIG_KEY_NOTIFICATIONS
+static int selinux_watch_key(struct key *key)
+{
+=09struct key_security_struct *ksec =3D key->security;
+=09u32 sid =3D current_sid();
+
+=09return avc_has_perm(&selinux_state,
+=09=09=09    sid, ksec->sid, SECCLASS_KEY, KEY_NEED_VIEW, NULL);
+}
+#endif
 #endif
=20
 #ifdef CONFIG_SECURITY_INFINIBAND
@@ -7012,6 +7023,9 @@ static struct security_hook_list selinux_hooks[] __ls=
m_ro_after_init =3D {
 =09LSM_HOOK_INIT(key_free, selinux_key_free),
 =09LSM_HOOK_INIT(key_permission, selinux_key_permission),
 =09LSM_HOOK_INIT(key_getsecurity, selinux_key_getsecurity),
+#ifdef CONFIG_KEY_NOTIFICATIONS
+=09LSM_HOOK_INIT(watch_key, selinux_watch_key),
+#endif
 #endif
=20
 #ifdef CONFIG_AUDIT
