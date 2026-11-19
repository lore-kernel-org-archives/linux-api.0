Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124143;
	b=17h7S2XLXKPune1ky8hr2fs07vU/H6NELwYOZmF42EjCrxIA0pKFqY44AQrWOJFDY5hr
	 lbhmSQ6ipazG6k3u8/n1UcHY1K6LP/tEWJMqLzAE2GGeFjb0H9uAXCUCtZzuEob8Xoqmy
	 rXD3s++ks5sdPGAlXzbCXAUqQHXcRyJnqpnlIE7DQPnM9QzUk6v01Mt/BMcMdhszBrqDh
	 dYb1kjoe5Hon4yuYs9BLts26CuJZ50FrzDn7CZrvCpKCjMpVUUrBNWRGfZ9g7ez266OJi
	 l9rgqQ+z+OQioIhllTEGIx09l+09oXveYQv1gmU1a6G86hIbCbWJDjmXhnzpgR03FdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124143;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=08XFKPlPZivWIz32hIgg4vqBbho/+cJ0DQm4DX6v8wM=;
	b=l7avrZKBCIUyBno3y+lxDni9irnS4mpqlohBfDtRlxrPUE3G4uQj3wer0VJOxyjBFlms
	 F+zSUk5sGvvdlv2VP+Mj4MRnaC6y1sJXAmGBpEoCM9fcuRpOAM2X9SxfrMlg7akws3By/
	 UNmt/SIGPVEcloM8377yYu9QgXT0ZBWwDy8OBmI5bbqTMaFFcW+yF/vtAQSyEW0T9+w5m
	 LgOoQt1nQ+XSZWu06+UdsXQliR4wFFU6ipvPkyuLuiFRdOp8BeZfI3xtZS0yUVENarEv2
	 v4+l8frPQK2oScdb85FDBL3M+M24m0AjGLhOhW1bQ/zbpfJv3QF9McdQITyUJulgklQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MxjRqEQd;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dyw+K4vj;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3C3606A320
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 21:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD3C3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MxjRqEQd;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dyw+K4vj
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJJ1ORd3814585
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 21:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	08XFKPlPZivWIz32hIgg4vqBbho/+cJ0DQm4DX6v8wM=; b=MxjRqEQdo8igcqFA
	0nghddsNiy7FqZtU83beYzTvymRqG26jTbkoI43aT04Tulzfrlk8srkTk++g9COq
	pZOH0eEHDC6InqLdPjyoBb6dcEMWv9d4zpEdblMot5jUyBgCnMC28RWnC+SR8DvS
	mmbSkMrISE+x1OHcLZS6vSNMdXgHzQFtCla5NPx9quhtlEWjfnw/aQPeIeKKJe16
	qJwoHNjJ3WWLMyI1i0TmzfDz0rRb5HJSLPKvd9/ew9+sCDrYPxso6ELYm3g2X0+T
	GraI4LbIGkhUeKbc3KCDnBLvE1ilGNvlTyicacdyDjih/2X91bXZ6wAUMe+LtxyO
	ssJHQw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j1xc6udeh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 21:35:42 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33713e5e6daso286954eec.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 13:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795124141; x=1795728941; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=08XFKPlPZivWIz32hIgg4vqBbho/+cJ0DQm4DX6v8wM=;
        b=dyw+K4vjfVH9zLmPJVlK08yDZJzKSPPiplcFprha4kSiTrvwcYZszQ8Wpz9xDW6YmY
         971whCdcOF0MLSe3UtB8Pgq+nW+Wmg/wHNG/xfIlcJmjCOqOgsRgQ6E0Hnc3EUcvT6tf
         Skh9dvCo7CdwY2pDPT/kNmQiimmm0T9aIF9XQHrfrtvPEEnF0esMpUjrBTmFjtGl0g0C
         +bfPzkV3N9qjGuiwm3yor2mfCsgHBgdQzvfZfaLAPfOfd6JyI/rHOrMDRZKkoh9DUWon
         Dl3egXyCnMPQA/K/1LH+uRSuJxmidjZpIOJKTu824rInhoOPfUqvrgmpOu58gvFIzN5w
         FOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795124141; x=1795728941;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=08XFKPlPZivWIz32hIgg4vqBbho/+cJ0DQm4DX6v8wM=;
        b=WOLZfRWsV/SIEgL1ETobv9SvMwEy9FgT1qKrRksmRbftXCRK03+wqzR23L54fzV/Mk
         L2YIhGkFt5O7ZSGQproRf8wFeZghyeHVMgzTKAHB4L9kQuaR9+VSAnZmQEt8hrO3qu/F
         KvA9tjtnfA7yRdmSpyWxQFPHG9PyREZfCCFqgXa9vAVBx78GkyEqQm3pb4JWBTXMA28V
         Zb6QkF9fL02w69UeLsjiS659edn0QAS2vzI4g2MPEbvT9c7ECLft/6QIjzPTT2rxcHSQ
         6b4GOsWvSZ5i916Uo7EXVpea6ZRPyCBPmmDJDcvXYF4V+PKSiOYnE56ZcCuurJ4C6ASK
         qV+A==
X-Forwarded-Encrypted: i=1; AL+hErEP7YFllsDAcnRx493fjg+Vp67JNuU7qqVOoIf42DhDVeu1/s0QysU2wsM6E8887FvifovP1O+d5qA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Wn9BCyckbb057M8YfIv9C/gRSkpeYWIBG1AU9KYT1iJFKy9Xy
	SRj3TDourT6dHvQ5QDiZtMFquZcnMDb3LYAoUNJ9P/jHlLT6McCKzCbAEZtx823HcvMXVx4Hu0z
	Cx80PCUW+DNUc5wr58IyxrSJ1pSuuZzBejLtDJCRiTG5UkkgI/6MQ/b3iZYAUi8Q=
X-Gm-Gg: AZFdTZfs4D6qIiVk2j6huCabXlPGdzQ32FfI22qrrXUqXvC5BQGGsJF6Ip1BAfUeLj7
	XHvYci44i0WWl9iEcLghPa9EWBNpdw5xGn+zWSkxCS8ZJ0G8CkmIbyGTq/tAuzOaHsVqkjVipUf
	jRCFQ6xPW05yItUZlJbB8Xpp03xpUXGMWi1FvG9BFaA+C+N1aYn/bI/AVCjqC5kCUXhA5T34QKo
	mdXbMbZ61SWfVIGp2ZYASwdYwcqgg1fwRfYQhHv4Lifb+aTSKGs9CeZSjzUIAuBTBasB9iInl2D
	O1mirbpThCkITcB/DGKVUw+Bp6Iygbyrjgj4Oz7GWUhdH9nEFEpM3kI9kKPaQGS6iAXV++2V3Eo
	8l+Zm484k/jTkPB7+CPXs37mnkMuMrTQhx8e8c9Rn1wwaeCMOiBa0rAQ2xBf5DZYyydx7aQ47L/
	CPgsz/HYKxgBp92IQmA5kXQcbR9GIB
X-Received: by 2002:a05:7300:ac82:b0:385:4b9:18f2 with SMTP id 5a478bee46e88-3857093f077mr861581eec.21.1795124141211;
        Thu, 19 Nov 2026 13:35:41 -0800 (PST)
X-Received: by 2002:a05:7300:ac82:b0:385:4b9:18f2 with SMTP id 5a478bee46e88-3857093f077mr861540eec.21.1795124140485;
        Thu, 19 Nov 2026 13:35:40 -0800 (PST)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e7f59sm1359625eec.6.2026.11.19.13.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 13:35:40 -0800 (PST)
Date: Thu, 19 Nov 2026 13:35:36 -0800
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Ahmed Azeem <ahmed.azeem@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Sudeep Holla
 <sudeep.holla@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
 <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mark
 Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Divin Raj <divin.raj@arm.com>,
        Bertrand
 Marquis <Bertrand.Marquis@arm.com>
Subject: Re: [PATCH RFC 1/4] uapi: firmware: arm: Add PFDI userspace ABI
Message-ID: <20261119133536.000013c4@oss.qualcomm.com>
In-Reply-To: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-1-4772d18b9115@arm.com>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
	<20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-1-4772d18b9115@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ef+o7LEH c=1 sm=1 tr=0 ts=6aff6bae cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=7CQSdrXTAAAA:8 a=JfrnYn6hAAAA:8 a=wc18U7BjuWp5DWxAL3UA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDA4NiBTYWx0ZWRfX6W1BMOO37W9K
 nNmPdTyDiHItQkW0SVvMY7cpFZHX37dT6niPg59+9mJajlzW3FcdrafpN5LTQO7kE6DxY5jmgyI
 tSyqhcW68EH79n7QSNAjU1wkVroI3L5zLTH2XLnAKsfoGgChw0+lkxk9U5wtkchsmoyDHr7CbvL
 R9vBELPNGVMKs1+hmdH/SqkeGIaaErBpg7CiVv9TxiMeuvhyL1LqfEUfgqivOs/58jpJ8fPy1Jw
 mWDrOf1Wmx4IgAwJ+TaY+Gm4aUexBcVywDfUF229MGKk6irZhRFOh9oYj10JGWd9Dufhnsx2oQ4
 VgnCgvQQsw+fAgOiDK/HH3Ds8GghdnhUfSc5viAjXqZyD0K3WcB3W+/daHxgyWjMYk9GA6kDNOD
 v8KiaiGW6kge39sofNX3eHZIse4NyGQvt8JQRlCWF2PqkumNdba1AQgw6M6xw3Swx7xa+hymNUX
 CfUOlgMslcf0CTjQXqQ==
X-Proofpoint-ORIG-GUID: IjDuAba7o6CNuzPfwTsQDNueibtDX3Yw
X-Proofpoint-GUID: IjDuAba7o6CNuzPfwTsQDNueibtDX3Yw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDA4NiBTYWx0ZWRfX2LuUPsgNSiQX
 1IP5Lv2mbbNsLhbzmTa5PE6MwfiNcgn0vcDQmL3FQCtgx5BZDMyGHX6Swk2hxNAITASjg7P86Y/
 4zwkJjguptBFzDuX7ZnI/2UZ+ltZa28=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611190086

On Thu, 19 Nov 2026 15:36:03 +0000
Ahmed Azeem <ahmed.azeem@arm.com> wrote:

> From: Divin Raj <divin.raj@arm.com>
> 
> Define the userspace ABI for the Arm Platform Fault Detection
> Interface (PFDI).
> 
> Subsequent commits introduce a driver that exposes a per-CPU misc
> device. The ioctl definitions, data structures, and return codes
> must therefore be shared with userspace. Add these definitions to
> a UAPI header and document the ABI for /dev/cpu/<cpu>/pfdi.
> 
> Placing the interface under include/uapi ensures availability via
> headers_install and clearly identifies it as a userspace contract.
> 

This is very much an initial look as until now I wasn't even aware
a specification for this existed. This isn't the first such
similar system, and there are likely to be more, so definitely 
worth thinking about generalization at least at the level
of userspace interface. Bit tricky to generalize SMC calls if they
aren't wrapped in anything.

> Link: https://developer.arm.com/documentation/110468/1-0alp0
> 

No blank lines in tag blocks.

> Signed-off-by: Divin Raj <divin.raj@arm.com>
> Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
> ---
>  Documentation/ABI/testing/dev-cpu-pfdi             | 103 +++++++++++++++++++++
>  Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
>  MAINTAINERS                                        |   7 ++
>  include/uapi/linux/pfdi.h                          |  89 ++++++++++++++++++
>  4 files changed, 200 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/dev-cpu-pfdi b/Documentation/ABI/testing/dev-cpu-pfdi
> new file mode 100644
> index 000000000000..e07ed6baa7f8
> --- /dev/null
> +++ b/Documentation/ABI/testing/dev-cpu-pfdi
> @@ -0,0 +1,103 @@
> +What:		/dev/cpu/<cpu>/pfdi
> +Date:		May 2026
> +KernelVersion:	6.18

Time travel.

> +Contact:	Linux ARM Kernel Mailing list <linux-arm-kernel@lists.infradead.org>
> +Reference:	Arm Platform Fault Detection Interface, document 110468,
> +		version 1.0 ALP0
> +Description:	Per-CPU Arm Platform Fault Detection Interface (PFDI) misc
> +		device nodes. Each node targets the CPU encoded in its

Trivial but wrap docs at 80 chars.

> +		path and exposes the PFDI service implemented by firmware.
> +		PFDI uses the Arm SMCCC SMC64 calling convention and is
> +		PE-local. Userspace is therefore expected to bind itself to
> +		the target CPU before opening or issuing ioctls on the
> +		matching device node. Each node is single-open: only one
> +		userspace owner at a time may hold /dev/cpu/<cpu>/pfdi for a
> +		given CPU. Additional open attempts fail with -EBUSY while the
> +		device is already open.
> +
> +		The ABI is defined in <linux/pfdi.h>. The following ioctls
> +		are supported:
> +
> +		* PFDI_IOCTL_VERSION
> +		  Read the PFDI version for the target CPU. On success the
> +		  ioctl returns 0 and copies a 32-bit version value to
> +		  userspace with the following layout:
> +		  Bits[30:16] PFDI major version
> +		  Bits[15:0] PFDI minor version
> +
> +		* PFDI_IOCTL_FEATURES
> +		  Query whether a PFDI function ID is supported on the
> +		  target CPU. Userspace passes a 32-bit PFDI function ID.
> +		  The ioctl returns 0 when the function is supported,
> +		  and -EOPNOTSUPP when it is not supported on the target
> +		  CPU, reserved by the specification, or otherwise not
> +		  recognized by firmware.
> +
> +		* PFDI_IOCTL_PE_TEST_ID
> +		  Read the test engine identifier for the target CPU.
> +		  On success the ioctl returns 0 and copies a 64-bit value to
> +		  userspace with the following layout:
> +		  Bits[63:32] reserved and zero
> +		  Bits[31:24] vendor ID
> +		  Bits[23:20] reserved and zero
> +		  Bits[19:16] vendor-defined implementation ID
> +		  Bits[15:8] major version
> +		  Bits[7:0] minor version
> +
> +		* PFDI_IOCTL_PE_TEST_PART_COUNT
> +		  Read the number of available test parts for the target

The naming 'test_part' is a little confusing given it could be interpreted
as thing to test, rather than part of a test.  I'd consider a rename.

> +		  CPU. On success the ioctl returns 0 and copies a signed
> +		  64-bit count to userspace. The smallest schedulable unit is
> +		  a test part, and valid test part indices are in the range 0
> +		  to count - 1.
> +
> +		* PFDI_IOCTL_PE_TEST_RUN
> +		  Run a requested inclusive test part range on the target
> +		  CPU. struct pfdi_test_run.range.start and .end are signed
> +		  64-bit values.
> +		  Passing start = -1 and end = -1 requests execution of all
> +		  available test parts on the target CPU. Any mixed use of
> +		  -1, reversed ranges, out-of-range indices, or non-zero
> +		  reserved arguments is rejected with -EINVAL, either by the
> +		  kernel before the request is issued or by firmware.
> +		  If firmware reports PFDI_RET_FAULT_FOUND, the ioctl returns
> +		  -EFAULT and copies a signed 64-bit failing test part
> +		  identifier to struct pfdi_test_run.ft_id. If the failing
> +		  part cannot be identified, ft_id is set to
> +		  PFDI_RET_UNKNOWN.
> +
> +		* PFDI_IOCTL_PE_TEST_RESULT
> +		  Fetch the stored out-of-reset test result for the target CPU.
> +		  If firmware reports PFDI_RET_FAULT_FOUND, the ioctl returns
> +		  -EFAULT and copies a signed 64-bit failing test part
> +		  identifier to userspace. If the failing part cannot be
> +		  identified, the copied value is PFDI_RET_UNKNOWN. If no
> +		  power-on tests were executed on the target CPU, the ioctl
> +		  returns -EAGAIN.

I get that the intent is that TEST_RUN is the runtime path and this is
out of boot.  However naming would make people expect this to return
something after a runtime test as well.  Maybe rename?

> +
> +		* PFDI_IOCTL_FW_CHECK
> +		  Ask firmware to execute platform firmware resident software
> +		  integrity checks. The ioctl returns 0 when no fault is
> +		  detected. It returns -EFAULT when firmware reports a fault.
> +		  Platforms that do not implement firmware integrity checks
> +		  still report success.

Why not just make this a TEST_RUN of test 0 and skip having a separate interface?

> +
> +		* PFDI_IOCTL_FORCE_ERROR
> +		  Schedule injection of a specific PFDI return value for the
> +		  next invocation of a selected PFDI function on the same
> +		  CPU. The requested function ID must be a supported PFDI
> +		  function IDs. Only one pending injected error is permitted
> +		  per CPU and function, and a new request replaces any older
> +		  undelivered request for the same pair. When the injection
> +		  is delivered, firmware returns the injected value in x0 and
> +		  zeros x1 to x4.
> +
> +		These device nodes reflect the PFDI 1.0 ALP0 specification.
> +		PFDI state is not persistent across reset or firmware update;
> +		userspace must rediscover capabilities and any test state
> +		after such events.
> +
> +		These nodes are intended for platform bring-up and validation.
> +		Access should therefore be restricted to privileged software.
> +
> +Users:		Platform validation and manufacturing test tools


