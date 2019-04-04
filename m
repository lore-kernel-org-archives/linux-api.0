From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V32 08/27] hibernate: Disable when the kernel is locked down
Date: Wed,  3 Apr 2019 17:32:30 -0700
Message-ID: <20190404003249.14356-9-matthewgarrett@google.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, Matthew Garrett <mjg59@google.com>, rjw@rjwysocki.net, pavel@ucw.cz, linux-pm@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

There is currently no way to verify the resume image when returning
from hibernate.  This might compromise the signed modules trust model,
so until we can work with signed hibernate images we disable it when the
kernel is locked down.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
Cc: rjw@rjwysocki.net
Cc: pavel@ucw.cz
cc: linux-pm@vger.kernel.org
---
 kernel/power/hibernate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index abef759de7c8..928b198cfa26 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -70,7 +70,8 @@ static const struct platform_hibernation_ops *hibernation_ops;
 
 bool hibernation_available(void)
 {
-	return (nohibernate == 0);
+	return nohibernate == 0 && !kernel_is_locked_down("Hibernation",
+							  LOCKDOWN_INTEGRITY);
 }
 
 /**
-- 
2.21.0.392.gf8f6787159e-goog
