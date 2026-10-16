Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE04D12B94;
	Fri, 16 Oct 2026 03:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792119796; cv=none; b=NUQfFmIzl0KKdYtSodUWuaxNgbqx1NRpoKQXHNan34IE17tvkvoVf5is8cL4eCBksIuCdS2qBwgf/OPvHQGw34LMKmSPHkEJELe2Nu+iCOK4A7etmlcoo9lcxcCdR/vqBkxGj/JClYePoksOAyQ4gZdR4GjlOEFfOaaOy2eSuoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792119796; c=relaxed/simple;
	bh=c5+Qn0u5dGLKbio/A2LqXctpm57GdwAam5o/vEj+s+I=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=nTcZzpCjOsMtyHox/8vxvMQKfIwsrgFdT0e4rs91TOxg+JiKtqYYzOAOOM2AMvduyD8e4pGa93ziym4vSS8UxXIid/HCJTrvCdrPkgsLLv3+v1miFB3ZTR3+TA+nDze/Db7CktpafLkH5o59ddGQRWTbu7JjBvFqd5emGyClznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=OKnn/Spv; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="OKnn/Spv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1792119782; bh=Zq3kt9ZuQAllMYj6cXvY63ia8/gcFZEyk9awgZJEUwY=;
	h=From:To:Cc:Subject:Date;
	b=OKnn/SpvcZKHIZnylQClOBF/lgeuMnZCHMfhMYucp1VWk8NFIvhkhC5+vrQcBn9h9
	 sL4IwYU7adwVBpfTKvRYKJu/zO4FX8w7QgxCBz9GnOKnSqk73Bm9uAavWTHf2bm9Ty
	 9AuPY+MTKWua5iRqhuJzx7f9Vndc4H9AAoCibkoM=
Received: from kernel-lab.tail5e91bb.ts.net ([223.104.134.165])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id BA9A251; Fri, 16 Oct 2026 11:02:58 +0800
X-QQ-mid: xmsmtpt1792119778tghfpzqbk
Message-ID: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
X-QQ-XMAILINFO: MvUAcPkRmFBfwgaTR9JhZbNfSWOrkIDOCz7D3VEXBitmACpX4fnV/d6Rswkgyo
	 GO6KOlg8JnggKymGW7GohkkMHpaQJtAWGKauGxU1XgvGi+Pv27NdIRmxVnjPHEUQG0/abCL5sNax
	 dns7uLy+sWUbXExmam9fsTMZmMsScwQqgS1neJky5lfeRFWx2C1hCuX7lpanVxiyrl1VnEChOjc7
	 8S+1YGhZ6fSug4t0yOBozU0yGGaqLsroL77Fy/uzSvQrLn+Jxp3Buq7Kn91VXqyoP+1SxIp714zX
	 ohfmzWqLa2NcL2NJw4F7sMBOnGaEw1+ti64e0s1Br/EuD0g12kuEl4JfbjTK7FlwJaSw49c+J5NV
	 N+Dte5MtUe2qM+IVQfLGNW+zU8M+ZobtBVriIEGlR6W0fUlznz+akUrUgqmewT7qXDfVrHEjgAS8
	 4aF//rBUlBX+JDXQanToGrIX4sK7Vnq+RDxNXXi0PLEAWC+SntP2rHpKM9esUxtGMlRqzczF/lbU
	 648styimpP6ViF0FXZk2k5GL0GpeaKg8SOXwuV4fMsbdElYdfGbbjOsR8jtH41lfjRIe+FmP6VYU
	 8+y8SIhFVc6qx++G3ZmlBXInWPJjQ+3sjlwFB4QghgPjZJVkooAdhaWMHoSGrgsgfZ1Xy/ocCzCs
	 f9AK6a2O6K2GglLgtBhHJgkbVHQascHQ0HCojVEdO8mjs9zAt9s6I3MCqW7M0cOvAPa87oplq+Ti
	 gYWCtf+SdgPCu/RYrZl3KeZMEgP+R3Co8JuZIw59P6lRZ37Txj1lJmwraWMVvqbFZLugQJFoY5cG
	 gCtWb6ycRAo4NHw24fDyK4gxpaII7CRYuIC+58SNi5NZ/KmG83SQ4szIZIhOCsBT26OUpRkiyJ0p
	 n5TynIOCvf61ww4I8o1Tu8VsgIt/9oduFPIMmCNjwp4VpxVw61AVHQkxZyEk3uWsxGUqyDDDenu+
	 jdNqu0z9CBgi+qB+g4l5M2PFBNtGXVCcwRLZyP/MViFhQ7PKkoMm8eFEuzNNr7Lne+VUq0Mfl1ZQ
	 de0knfaWXw6354s89nJ0pcUaQbgPggiGbo55jEKDEi2oRkNjaiLZh6frD18JslIiwqENIwYA==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Yingjie Wang <1075151112@qq.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	stable@vger.kernel.org,
	kuniyu@google.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	Yingjie Wang <1075151112@qq.com>
Subject: [PATCH net v3] net: unix: reject negative max_dgram_qlen values
Date: Fri, 16 Oct 2026 11:02:58 +0800
X-OQ-MSGID: <20261016030258.2027522-1-1075151112@qq.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net.unix.max_dgram_qlen is parsed as a signed int and copied to the u32
sock::sk_max_ack_backlog when an AF_UNIX socket is created.  Consequently,
a negative value such as -1 is accepted and converted to UINT_MAX.  Since
the receive queue length is also u32, its fullness check cannot become true
for that limit.

max_dgram_qlen has no documented negative sentinel.  Its existing signed
interface represents nonnegative values only through INT_MAX; negative bit
patterns are not a supported encoding for the upper half of the u32
consumer range.

Switch to proc_dointvec_minmax and make the established 0..INT_MAX input
range explicit.  This rejects negative values without adding new accepted
values or changing the default and zero-value behavior.  Very large valid
values can still make the queue limit impractical to reach; this change
corrects the input domain rather than imposing a new resource ceiling.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Yingjie Wang <1075151112@qq.com>
---
v3:
  - Keep the signed backing type and preserve the established 0..INT_MAX
    userspace range instead of extending the interface to the full u32 range.
  - Add an explicit INT_MAX upper bound and document the accepted range.
  - Clarify that the change validates the input domain rather than imposing a
    practical resource ceiling.
v2: https://lore.kernel.org/netdev/tencent_9FDB4FAAFE9F3EF38210AC963C73897A2E09@qq.com/
  - Change the backing value and handler to unsigned.
v1: https://lore.kernel.org/netdev/tencent_4AD5738B48FDD2FC84E21FE59338C8DBAA05@qq.com/

 Documentation/networking/ip-sysctl.rst | 3 ++-
 net/unix/sysctl_net_unix.c             | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 208f469..776a3f7 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3821,5 +3821,6 @@ l3mdev_accept - BOOLEAN
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 47660d5..fa1fbae 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -19,7 +19,9 @@ static const struct ctl_table unix_table[] = {
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 };
 
-- 
2.43.0

