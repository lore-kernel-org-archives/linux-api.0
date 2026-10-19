Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445947;
	b=NMBTxVfD6agusL7tepZiY4JVY5jSinxf+8Ls0qGoCs27sVM7t7F8pzQpJlP96SfI/Sld
	 lyo8NKlLi29KAWHqLGG2EupHQiO4DlzasAoKmj6BLS+yLyqoNl7GyPPNy/Tbru1IU9MxF
	 XcR1LKKv4ZCV33yLdw09lOR6pO1KKVCEVTidYZav980Ubx3ap4LwxvMKY7fxbemGJGQcV
	 ZnShOB6iNqzlkUkQiahVIidwMzT0gsytpJJYAHl+ioiWWwuFspaUQQn7EeTEI/lJJ4QeR
	 NsD253FKUZtg1kWt20nPFKZ1wMUVN75RI89sp1c0JMCUV00ZCjeKIuWh1DRRHDD9vlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445947;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Wd2EROnbxYAIq9WpklnhYWqU+88INgWCUrvCQCoE1Gg=;
	b=i8fRPNjPNB0GZKxadhi6v1j2zN1wdk9jMkR1TMJT0ljPem333Ofz+K0i1CF5wY0aHsMy
	 gelpSAvw1QHVnlLNcZP0pkaFBxYOpv+16mGJw6UPISvb2eVN0PTYDw3b5Hv9x1RSuzu0y
	 itM55xSJ7RE9EDhWyMpr1juG6DUSWVNXySOd3l/Jd7JXfaGZoZsNBP9w/mARBjNzi1SIK
	 0ji9JbeDdRV/JxPnJ/efBvoxdijbR8PGJKXf/vaPqHHVHHBwhd5dndzyTsr2/VVbpbGRH
	 H1ArRmX81sE9xPzcjQNvoZJa3cHmWd207XOK3hFOz8HF0ioLBUagt2+2vEK/QiEm77Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=4UIh6c1G;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7306A606A320;
	Mon, 19 Oct 2026 21:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7306A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=4UIh6c1G
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Wd2EROnbxYAIq9WpklnhYWqU+88INgWCUrvCQCoE1Gg=; b=4UIh6c1GvlKZyg+WlP5kKK5g2K
	jHtrcG80vOhM1II7AyBk3coPrCwNoEUZVDeRxLZrEnInpZDjkH2Kr0LDRvj3O/sNpv6RXBLmlKd2k
	fyJ/RiEazPsaCCw8+WIfTxBmV4abD+vGwoysxREbNUrzAzVP13Z92OtfEoHyLVN+jipO/PyWhlc0V
	Y+CUp0uOmNfkkMtLhG+8SLLMkxkzVo2u5kQVvhI/i5+JES2NhlFURgwF11mYsZZYZPwbUwbc1emXc
	pQ4WHp9SxSAcIBJQjOzBCK9AVAqNNCS0I4ieWVPg6Oyyus6ZfvCGtpK8xqHugjUkyniLU1Woegbbe
	nl+LsHGw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xIv4J-00000008Phd-3tqC;
	Mon, 19 Oct 2026 21:38:55 +0000
Message-ID: <4ebbbb17-7833-4a2c-9e7e-b3c731873caf@infradead.org>
Date: Mon, 19 Oct 2026 14:38:53 -0700
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 18/18] MAINTAINERS: add beamfs
To: Aurelien DESBRIERES <aurelien@hackers.camp>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, aurelien.desbrieres@gmail.com,
 linux-api@vger.kernel.org
References: <20261019041728.327785-1-aurelien@hackers.camp>
 <20261019041728.327785-19-aurelien@hackers.camp>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261019041728.327785-19-aurelien@hackers.camp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi--

On 10/18/26 9:17 PM, Aurelien DESBRIERES wrote:
> Add an entry for beamfs and its documentation.
> 
> Assisted-by: LLM
> Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 62744835f86f..e5b95458da43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3082,6 +3082,15 @@ F:	drivers/usb/host/ohci-nxp.c
>  F:	drivers/watchdog/pnx4008_wdt.c
>  N:	lpc32xx
>  
> +BEAMFS FILE SYSTEM
> +M:	Aurelien DESBRIERES <aurelien@hackers.camp>
> +L:	linux-fsdevel@vger.kernel.org
> +S:	Maintained
> +W:	https://github.com/roastercode/beamfs
> +F:	Documentation/ABI/testing/sysfs-fs-beamfs
> +F:	Documentation/filesystems/beamfs.rst
> +F:	fs/beamfs/
> +

Entries in the MAINTAINERS file should be in alphabetical order,
so between these 2 entries, please:

BDISP ST MEDIA DRIVER

BECKHOFF CX5020 ETHERCAT MASTER DRIVER


>  LPC32XX DMAMUX SUPPORT
>  M:	J.M.B. Downing <jonathan.downing@nautel.com>
>  M:	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>

-- 
~Randy

