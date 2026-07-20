Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABE2446C18;
	Mon, 20 Jul 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568941; cv=none; b=ukUGgPD/6c4KucUFAX+RPYOEBvhgpBXkjeeQA4zUiZ+LljEv6SSOk8oydTzGcxsk6vu1tmSEx73nFe7g4calr8hpTTtYkIG/EpX+uB9QU+A1EXnEDxeM+S3u3ygpB7AOPc9B93EQkm75ItRHZvuM9Nrt+nEtir0Nh3esruC4TBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568941; c=relaxed/simple;
	bh=+vu8CXOB3dhB9djQatJr0MSEd8mqUG1o3rs661gkyxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vykc4FrzdueR8QWPQSDUiRNTMJkAf7/eKLBtcpI5k08HUMVseRxGrZxX+3E/f6MYr0x+MEl+2CxeLQe5zouzFmuVFWVk9c1AgftIN+8ffUvUSj23/Ft5vgxBng7ytRRNN7Q+tnIBgDHY9W2CmcFqRumxcN7rg7+OLVsmc47l9U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=M5Hg44lx; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="M5Hg44lx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Pd1wrIzqviiVq8qXfyOQyxJp1AOwdmiy8OG3eq1ZRmA=; b=M5Hg44lxcPOY+kU5yTo3rg9BFD
	3Z7nKdqMxlwQ7HgTvVCKAvg06b/eHDOgjtviTXWLx/7dFEAaMOOB1ojP4E+gPZIfapCdgW7PY+H/I
	EGE4lk5ZnlSw5zmmbvpjVKAIneUMKMpR2NKyllHt5TuZ8F5JkClNWoaPm2RdXGCqfmf5qF889DjMo
	AGuE8PsG69m175REzZeytNVkCL+ajpTEq7GMo/U3buTbJQeEkHSr8nepIGnwZezBxVn1MjETKzJL0
	aYTfWaGqN+jZNl11LfMNIf/cq1TfONniAW7j++g2LO2kkpsrjU2RizFgl7mhtS1CZI/eCLAm+7/ik
	XexIGNaw==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wlrcg-001Fmy-03;
	Mon, 20 Jul 2026 12:17:46 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH 1/4] docs: ntsync: align uAPI ioctl names and struct layout with ntsync.h
Date: Mon, 20 Jul 2026 12:17:37 -0500
Message-ID: <20260720171740.447035-2-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720171740.447035-1-zfigura@codeweavers.com>
References: <20260720171740.447035-1-zfigura@codeweavers.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

The userspace-api reference used stale macro names (SEM_POST, SET_EVENT,
READ_*, KILL_OWNER) and struct field order that did not match
include/uapi/linux/ntsync.h. Update the documentation to match the
published uapi so Wine and other consumers grep the correct symbols.

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
---
 Documentation/userspace-api/ntsync.rst | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/userspace-api/ntsync.rst b/Documentation/userspace-api/ntsync.rst
index 25e7c4aef968..535585331380 100644
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
-- 
2.53.0

