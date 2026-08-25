Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03863ACA74
	for <linux-api@vger.kernel.org>; Tue, 25 Aug 2026 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663014; cv=pass; b=oqkTTFLiZDkyxn8kTFPFGpG3A+u397fptN9M1xVbMY5DmcGX0xPg4vgBOBQQqjg2oCNFYMy3mcwB6xgJlW3CmZvDg3gjOdpmV8QNvvBhrIBZzJaaR8AGoN0CJybTlro+a/gAHy92wDBYqwZk8sZgbUed9ya8BRi+clD9dwFRYfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663014; c=relaxed/simple;
	bh=CUEr/e5MholbNaYQzXTmEQ6JBM5Dsq0Y//IYN7xJv38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qG38AubZtgVYXkbAcPqs0MT2MHevokrfPY4XB44nJOMKLebukkcb4nFEpYU+PvBVB7iJdvT7kEGVixftwP0Ydu7KOazX8X8zUEpgK7YAnJwMeyVNZjNQmU5pZ3iqIbARVDuo72/ZQcAA96SiKQERXdWmyrLth/zut84ZEdaQBRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=n5COpouL; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="n5COpouL"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51bfa429aa6so4393201cf.0
        for <linux-api@vger.kernel.org>; Tue, 25 Aug 2026 06:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787663012; cv=none;
        d=google.com; s=arc-20260327;
        b=FuUrYzDMO8cz0K+UDNGYhA1X2gWmVt+uhWagGU6uNFlVr3KX4I4uAPXObZ6QHXeFA5
         2wsUDdU4o524egL2F+aBXym/DdaX12pxc2ih1LtFhgMUVQW0qCg4k3U6qAv0kcnKwa+a
         PX1lSQkotOPT6qJh3B/eymvYj/JUI9yMVlUovzLtqXiERzD5OIqy50XZRE54nPqZ1att
         p5a8vysDrd5+rxoKEEbGehQnLSZTTF490rE/Ur5z6i1xigX9dr3id213dskudh2QUOPu
         f59ITVXcIKfbp+gCJG/D+MCXDhyF093v+TzVnB61WbUQt2RPustgLabO332qRVlWVqgr
         3EFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CUEr/e5MholbNaYQzXTmEQ6JBM5Dsq0Y//IYN7xJv38=;
        fh=CgCT6jpUB9ElawiUonrsBvq4LrRLVmc0MaUk8VLhzto=;
        b=psG6F0Pcp20kj/8uhxILF6T4vg5ALzfHOpz7eQvvmEEzyVQjiqhdU5mUz18vyiNt8d
         VSO/6QzZiiua2QEteaYz4YcRMCn2eHKXbhMcioPuf/pZ9cEWG6e+w0fFlAw+5FSBKmph
         WAw5+8umu43pJKOMIROQEVUcjFSnBX7I0N9AF+Qgg+b0KhPOETZ2hlfIS/uo4sR90g7t
         SN44JPAyCkgSRtnYKu1YNxOebBrlTY/LBcIgbTUYjf/Kj0NuZ8ZI83uxr2wq36Vok4Yd
         PMiDxhsPD6h+NVOP46ucq0E1zMP73obZ12i9jUWLGozP0E8mw3RjBxU9x3EpfBpqmpow
         DaKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787663012; x=1788267812; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CUEr/e5MholbNaYQzXTmEQ6JBM5Dsq0Y//IYN7xJv38=;
        b=n5COpouLZ7/pu6vDx0tKKHsjHdWo3SHFIv07G02o/UsZtr8QrFk5atSSrj6tZFProP
         hpsSiQUtJKtOhxBL0OPCEeHu/PmCZazX1UZB+ibkluVlduXpvXVvUX8+PydDSOXWjPwZ
         UDWW2uKDwdRwCSyjzhvYGXRu4mZU9Zaksmv4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663012; x=1788267812;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CUEr/e5MholbNaYQzXTmEQ6JBM5Dsq0Y//IYN7xJv38=;
        b=efA4cu8MY5/BawZACp5O0HQ+puMEh0RqlmyAzMtvgc8WcEw4wMIxO9oNUhQopUS9f6
         hYoWxJ1Kbt5nDBNpe2gbzQ1Ley0QyMq1UTqI0nMdlO/+oUuwCZF4/DR064mZcSruFURD
         hSrNrHloO0xL6yZ2m3OhQlUri/ff3gCTDNhWcWdp0yN8xJsBHTkjMc8GfUS69oaMThM+
         cqZHHw+a5eV4LZls7wm6C0g9hN5j2tzj/jIpxYYgOjQbTE+8gNPke5pVXVGgRLENSlhS
         RKM3Mr/gcePJ8nDPxkr/KHA4F5DAjInV7GrzzunFNjT4JUWT3MgIPJl40WCiF62fvQIv
         JUtQ==
X-Forwarded-Encrypted: i=1; AHgh+RpbuTAz9wDHbVHDxBo//YRvDR7lfWuoJTBYHLjvvsRHiKECTVrgu64pFsbLH8usGJcTTgGHLndhv+o=@vger.kernel.org
X-Gm-Message-State: AFuF++lmFke5eZith8kwbJd+nEPH8kLh92cpOqMzDTtgB/6a8z+6PGry
	yFF9ZZhJPlxt7Nnh9V+CwCk6pEImU7qFYgsC40yGZoSOIH8ky/25Y0cto2Vl3bGkEt/R6MyhqPq
	x8gPx1AtHlthsgR0NXHcxHUsF+D//g6y+99wOfgot7XvL9APRFikF
X-Gm-Gg: AR+sD13nne101fGJq14k17jUe3Qv5ZiIlM+LhmiOPczu7vSQhd5KEmo6o4reV5j8Oq7
	zqRFPXMQt5rrg1nYl4wTwOKqElXcwMsxhFHQnaq36M9dz2zUAuLCvmQrddvhIYVrPIUDiNnGgqv
	h0vkdEcS5DwP+RfmWL2fDudbcblWsYwhM1zRe2Nip+tP2eef/pggmaxRgnTVh0h8/ieonR0V2cr
	C9PxInnCxIBj8VaOnlTQltlyadQ2iCfsHLcz6/AS5WME38TkBUCpqAPkDm+P+wTFuML3friA88l
	1ady2Zi3qrkN3pdMvt3nl5dwJSF+Q4+UZgXULqvzcd9Fikc0pMvgYpahD+bYl041rBmUanY00ut
	dB80=
X-Received: by 2002:a05:622a:118d:b0:51b:fb5f:b263 with SMTP id
 d75a77b69052e-52e2ec1e5demr67516461cf.4.1787663011283; Tue, 25 Aug 2026
 06:03:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820130158.254808-1-jamz@amazon.com>
In-Reply-To: <20260820130158.254808-1-jamz@amazon.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Aug 2026 15:03:19 +0200
X-Gm-Features: AcwNN1V-E0YVDUa4WhV6OmS9gRNJfrQeO1sZEy5JreCrY0gVdVTUszFjJtAbGlQ
Message-ID: <CAJfpegsR1oNh_PnmK-a+k=6ttdpXYAyg6SsQe=ZMCZN03gvPhA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] fuse: allow FUSE_SYNCFS for privileged userspace servers
To: Jimmy Zuber <jamz@amazon.com>
Cc: fuse-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Aug 2026 at 15:02, Jimmy Zuber <jamz@amazon.com> wrote:

> This series lets a plain /dev/fuse server opt in via a new FUSE_HAS_SYNCFS
> INIT flag, honored only when the server opened /dev/fuse with CAP_SYS_ADMIN
> privilege in the initial user namespace -- checked with file_ns_capable() at
> mount time.

Applied, thanks.

Miklos
