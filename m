Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA453E3DA8;
	Thu, 23 Jul 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837601; cv=none; b=I9tkGKiU5+JOeX0c7lxE9dCPRG4JBDnrW2ZjlK6fWoDDbw+RFXI5fzizuXqUMIFWejPpFeHSLudNlWbFXxgYLG14VQBmQ5O5acfj8jepYPJrNjKXgIICsPj4wlzu65vy+1eCcxrn7cfnpRfzrcJNCxIZSI3fl6OV/PJAQQMfLxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837601; c=relaxed/simple;
	bh=Xf7wAcoRtFZotd4VLVhITpCZt9cl7v4vEeMx2/JpWzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hp+6Ao65m3H0m1UKFEZ0SMfCk3XOkf0kg87VtzDxX5h7kGJCQxOpLP0ukhtJ0XcSpQwPMB0GqWhLj/aGBKJWu5YroLxoDV23KjBE4Ccy6/a5IEsb9Xkec6KqxMVTI4of4SYmLFv2LUa/y5knA7rqXEkhbygv4tLjJjx9dk94wzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=D9VoTu5m; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="D9VoTu5m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UxuQK04fIAEZo/d2eQ1fm293Y0mtwcRrhlz+o59yJjk=; b=D9VoTu5m6TSRY3x6ZeOiYoX68c
	r/BSYPLo47MrCmvDEOT2A+xGhBZIyTuDwoRtmLtcK+RVQPiScqrKKMXYf1aBEHpwLzpHll+t8UmxK
	vC3Or86kdGEEKusHjswdoXtaEmU+JvYRGWRPj3PaeUBWDzjKlRNaTeXS7qeNSupRTQgphWTfdPjSq
	jiDiLPWPJGuHKyHSde1Z2utM9jK2UtV4bwtcWPTzBRS5OPnIMMYlHTlsR1DYg/gnbwGHWr3J9daEB
	wmSfX2OA2r4acFYSbwRr9Fu9EGIDUkgZVj23ZOa5Qi918Us8kiwoATOSlhkMX9Xl6kN5Hz8ACcfom
	QBNExonA==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wmzn6-00AV4U-1f;
	Thu, 23 Jul 2026 15:13:12 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH v2 4/5] docs: ntsync: align ioctl names and struct layouts with uapi
Date: Thu, 23 Jul 2026 15:13:00 -0500
Message-ID: <20260723201301.11826-5-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723201301.11826-1-zfigura@codeweavers.com>
References: <20260723201301.11826-1-zfigura@codeweavers.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

The uAPI documentation used outdated or conceptual ioctl macro names
and listed ntsync_event_args / ntsync_wait_args fields in the wrong
order. Match include/uapi/linux/ntsync.h and note that absolute
MONOTONIC timeouts are interpreted in the caller's time namespace.

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
---
 Documentation/userspace-api/ntsync.rst | 33 +++++++++++++-------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/Documentation/userspace-api/ntsync.rst b/Documentation/userspace-api/ntsync.rst
index 25e7c4aef968..a778016feb87 100644
--- a/Documentation/userspace-api/ntsync.rst
+++ b/Documentation/userspace-api/ntsync.rst
@@ -83,18 +83,18 @@ structures used in ioctl calls::
    };
 
    struct ntsync_event_args {
-   	__u32 signaled;
    	__u32 manual;
+   	__u32 signaled;
    };
 
    struct ntsync_wait_args {
    	__u64 timeout;
    	__u64 objs;
    	__u32 count;
-   	__u32 owner;
    	__u32 index;
-   	__u32 alert;
    	__u32 flags;
+   	__u32 owner;
+   	__u32 alert;
    	__u32 pad;
    };
 
@@ -152,7 +152,7 @@ The ioctls on the device file are as follows:
 
 The ioctls on the individual objects are as follows:
 
-.. c:macro:: NTSYNC_IOC_SEM_POST
+.. c:macro:: NTSYNC_IOC_SEM_RELEASE
 
   Post to a semaphore object. Takes a pointer to a 32-bit integer,
   which on input holds the count to be added to the semaphore, and on
@@ -186,7 +186,7 @@ The ioctls on the individual objects are as follows:
   unowned and signaled, and eligible threads waiting on it will be
   woken as appropriate.
 
-.. c:macro:: NTSYNC_IOC_SET_EVENT
+.. c:macro:: NTSYNC_IOC_EVENT_SET
 
   Signal an event object. Takes a pointer to a 32-bit integer, which on
   output contains the previous state of the event.
@@ -194,12 +194,12 @@ The ioctls on the individual objects are as follows:
   Eligible threads will be woken, and auto-reset events will be
   designaled appropriately.
 
-.. c:macro:: NTSYNC_IOC_RESET_EVENT
+.. c:macro:: NTSYNC_IOC_EVENT_RESET
 
   Designal an event object. Takes a pointer to a 32-bit integer, which
   on output contains the previous state of the event.
 
-.. c:macro:: NTSYNC_IOC_PULSE_EVENT
+.. c:macro:: NTSYNC_IOC_EVENT_PULSE
 
   Wake threads waiting on an event object while leaving it in an
   unsignaled state. Takes a pointer to a 32-bit integer, which on
@@ -213,7 +213,7 @@ The ioctls on the individual objects are as follows:
   afterwards, and a simultaneous read operation will always report the
   event as unsignaled.
 
-.. c:macro:: NTSYNC_IOC_READ_SEM
+.. c:macro:: NTSYNC_IOC_SEM_READ
 
   Read the current state of a semaphore object. Takes a pointer to
   struct :c:type:`ntsync_sem_args`, which is used as follows:
@@ -225,7 +225,7 @@ The ioctls on the individual objects are as follows:
      * - ``max``
        - On output, contains the maximum count of the semaphore.
 
-.. c:macro:: NTSYNC_IOC_READ_MUTEX
+.. c:macro:: NTSYNC_IOC_MUTEX_READ
 
   Read the current state of a mutex object. Takes a pointer to struct
   :c:type:`ntsync_mutex_args`, which is used as follows:
@@ -242,7 +242,7 @@ The ioctls on the individual objects are as follows:
   ``EOWNERDEAD``. In this case, ``count`` and ``owner`` are set to
   zero.
 
-.. c:macro:: NTSYNC_IOC_READ_EVENT
+.. c:macro:: NTSYNC_IOC_EVENT_READ
 
   Read the current state of an event object. Takes a pointer to struct
   :c:type:`ntsync_event_args`, which is used as follows:
@@ -255,7 +255,7 @@ The ioctls on the individual objects are as follows:
        - On output, contains 1 if the event is a manual-reset event,
          and 0 otherwise.
 
-.. c:macro:: NTSYNC_IOC_KILL_OWNER
+.. c:macro:: NTSYNC_IOC_MUTEX_KILL
 
   Mark a mutex as unowned and abandoned if it is owned by the given
   owner. Takes an input-only pointer to a 32-bit integer denoting the
@@ -276,11 +276,12 @@ The ioctls on the individual objects are as follows:
      * - ``timeout``
        - Absolute timeout in nanoseconds. If ``NTSYNC_WAIT_REALTIME``
          is set, the timeout is measured against the REALTIME clock;
-         otherwise it is measured against the MONOTONIC clock. If the
-         timeout is equal to or earlier than the current time, the
-         function returns immediately without sleeping. If ``timeout``
-         is U64_MAX, the function will sleep until an object is
-         signaled, and will not fail with ``ETIMEDOUT``.
+         otherwise it is measured against the MONOTONIC clock in the
+         caller's time namespace. If the timeout is equal to or earlier
+         than the current time, the function returns immediately
+         without sleeping. If ``timeout`` is U64_MAX, the function will
+         sleep until an object is signaled, and will not fail with
+         ``ETIMEDOUT``.
      * - ``objs``
        - Pointer to an array of ``count`` file descriptors
          (specified as an integer so that the structure has the same
-- 
2.53.0

