Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793400247;
	b=tnvSAeJgq2N9/otBybig6+5nDsXqYQbw9tD2SyGbcbXppRMCTHT6zoH02PmtPNl+Dxus
	 1TFANTxv5BlBzmKCaFSi30Cn/LYKo/Z017Mo/hYP1Y6vmWRGGPszUCzBwc5iJhOyC/cz4
	 5RsrrLs1bkNpAYNjaDcpuYfJOLkZb6nP9epsMShN25rXTUSmmvbd+nh8HxG/mw1EieICM
	 0PuquF94kUPj4FdUJRgmKJfOB1E5wUeUyU/mxdeo3GfKf6ynucwiEtfDQw/Ek2Jyk5HVl
	 8PIypq6Rx7NUsn9WKgsqUmdGytW7RxG0eABD8Dm4vrqVytSBe4qP8ioAD2RFjxbwomg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400247;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
	b=v7XSh4KiT6w8ikE3i0gwTEgn8zYXZhjEhNzHA+G3eY+X7Ia5wBbRhZIWzyBgXG01CrHf
	 y4Mk3Eo5B3tt4597LZB2JXnWW4PcPkmTNy+ml9BU7M16xXig9ebHQItJEauNMpq0erAF6
	 wDC7FGK2QNPHClLLOq2uNbIVR+uDi6pmrwVSQWMoqGnZ3XziXtzslN9H944ziMGKZG5Na
	 w5OCtZnfkLR+rXDNd05LsEB9RuN5wlmtVbTaenJMYzY3vRApg6ltS5QoiVbq/HsDbaRpj
	 pBnqgreRGCVhPacZx2585eSmTDsiyPdD8vVzwMl1CEhR3o6xppRDnBb4sdiyN5OnOTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DaiZLmwQ;
	arc=fail smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C782606A31C
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 22:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C782606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DaiZLmwQ
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bfa686881fso1002136e87.2
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 15:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793400245; cv=none;
        d=google.com; s=arc-20260327;
        b=NttGKJWvp1ttNdlZ2XdvKXPZbzX5G3ZxTUtmcIe5X2EW76HTKZppoe0Dr2K8rH+y+a
         fGlMgwOu0Ob70VN2m3iHbRlN6eextqX7CZIVyaMi5DAhJrSVgxHoOUUhHEyybHuQT9fg
         YEWD85o4dPkp3on2FGHVNsSmttNmHGjE5mIlQImjhepNI05q+FCRhPG7ltGWt9F/I6GI
         pwgPSG8y4jQip/vcpE/+4U4PYDzqDsIgTvBPZTz9uEhjEBIBii9hFv6Y0bUuShPp+FQ+
         4UiY5f8NbfaZymu7xcf6vqmG1/i72Bh/1y4X9RQ8Pptdo754EO4ohnc4xFCB0JyBapvP
         oAHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
        fh=hS8t7lrFDzRgepCUUheT76ZTcHFJ0fay6F1zoLXCj+o=;
        b=MFEVqGdWqrLGRNtejYMjZNM1y/6W8MVJTxSRyAJJljKtDds95sjrQzaRDRmqcQf+UU
         556HOMZeSQJmEjSB/UhQtSD3NHqWCp+P/gReO8Uopq440FluVydvP7U3yK4YdSr6AKZu
         BPiqIqDUi+uYR8YzSm/D/5SVbPEX7/3ucqsxMJ4NA/Qi5foBLi4XgeMgaEFI6iL2pMKY
         7Lkqtpvwg4s4UczrwmdRgLB00doBv9VN8D1weMYQwZr3kEfkAWkRnEQaDMmTlVP1DsBY
         JEdYolvEqCM+7WTdZ8pPK0E9M+CloMm2VQRYasx46Klahgmgoa8DxGgWVq9RGdJ1o5Ae
         IVbA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793400245; x=1794005045; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
        b=DaiZLmwQeVKbbcdVOyDCZyZxvLmchXpkwa6kU1MTGUpPaTuPAdDfGq0V4QSy0+e7bX
         b0djsAS8FyOOR3W52Qg6YzAzerrLCBVpq7nY+MxSj0j5lIi2ungzeDifs29L4IGMfolk
         vUkRosIQQ1t+JOdfgYq5iXS7fw9pjV7FBSmpiC1Zgex2wat6xMyz7LwVHydh7FZQ18Pk
         V5U1+RQU9/KzyxvYcSFLDB4cWd1lv+HjWcchRSFrFwNd+9add2cR5WSZFMgBjt05oqSY
         uuu1CuFi3rF5jSHSUWu5guBupRZ5HM+kS6UfQLzvmZ0E/CaNK/UbRTu0rtCd1L2LT4O6
         nvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793400245; x=1794005045;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+vnvo88Pr3dQY7eSVbimo7vIzM+xuPPq1OrMINl+rL8=;
        b=zU7wDinYKDBY+fWyPPb5HtQg8EzzcYzT6oviGGhsXRijBhz1C+E9zS7cWIRdHMi6/g
         vGVcBH7JSx2X6WgmVq8ooQC6QXrHUY3xm05eBl+tE6Bsd1rgkKWO0sdWTffC+d69dN0I
         Wj3HXCnpLbWTuq2t473aE14pxugtY2cu3aWkqlJodGWIQ5JYza3lMJ0VpUeO/8XKcrjb
         xyMFVxIfPZp9zFiYVpN4H0ftHP7MIkeBLKNgFjSQLHmDUVEXg1L2z1ZDhjlyRGrgfXpA
         nhCDA7Brriax9pos3ZANeqfAWeYD4kMkj/oN2n0auylagM6lErtoiNKfUYkcQfqsCkA2
         2Svg==
X-Forwarded-Encrypted: i=1; AKwUvBwnHznEmyuum9g4cQGRa+ABRfJSb+mcAeyAJ3nFvPw9tgCVl5COADM7VMIXck8UrfrHIOGsRPwjwU0=@vger.kernel.org
X-Gm-Message-State: AFq9FYL1U5gTDEWelK1Rb/Ys63yGY0yX1QU1ia6rgU3hL+Fs5+ourxHM
	XY6vhBNegopdU4Py4Nwsbp/DCj/LaFAn9cJ+SVA6sYbA/FmtDSq0slo7qAVIYhIBzwxYLgx1YUF
	tfrjgI04Os2AaPIv9Kg4F6ou9TxSY27n+yFYlnuDn
X-Gm-Gg: AYBFou3YX+K0Wxp4cCXWQUZhfaksB0Oc+t4R/eXn92nBLYTLU6/yFfTf4EDSE9DvPm0
	IsZxdBNFEY2DEMLv1fHea2RxEbRz7OOnYlwcY5ROs7E14tJ4HBqSiggG6HjiwzFC/Cww9dJy/4x
	bg2cFm7m02ceWRmBlNGlF9zkNuZGr4q+nKbFypjjFCQiHGbQ6ihLoe5ONwti6XOTM/6uoO+M1Kn
	ngyoWSt7T354o2EJqtmmyRc8NmxTW46v2S3ckGkYcyPG8QI8Cr/p688Jq28BglKm/jtwTKtIdRa
	fytYp8sci02+Ie2xhDxTGkB+hP2GNxXKyzdSZgb3aGi5h3AA8G+efFSm86pId6fAQsIK6gvSKGr
	/eCdnP7uqJmkQ+SGdyIcuAeIElwFttD+PhA==
X-Received: by 2002:a05:6512:a94:b0:5bf:b246:87a2 with SMTP id
 2adb3069b0e04-5bfd957b610mr1268679e87.10.1793400245078; Fri, 30 Oct 2026
 15:44:05 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca> <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
In-Reply-To: <auTR9SnDLsLVmnJ7@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 Oct 2026 15:43:53 -0700
X-Gm-Features: AclHuK84pmgR6t7GwgKZ09yPCaz9JinHcZg2AVlK1zJKyqi05vBjmcmKbMe2QqI
Message-ID: <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 10:40=E2=80=AFAM Samiullah Khawaja <skhawaja@google=
.com> wrote:
>
> On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:
> >On 10/30/26 13:11, Jason Gunthorpe wrote:
> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrot=
e:
> >>> On 10/26/26 23:05, Samiullah Khawaja wrote:
> >>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prev=
ents
> >>>> holes from being punched into a shmem or hugetlbfs memfd while leavi=
ng
> >>>> the file fully writable.
> >>>>
> >>>> Background
> >>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>
> >>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> >>>> memfd_pin_folios() to pin the folios backing a memfd and hand them t=
o a
> >>>> device for DMA. Pinning keeps those folios allocated, but it does no=
t
> >>>> keep them in the file. If userspace later calls
> >>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range=
,
> >>>> the folios are dropped from the page cache while the device continue=
s
> >>>> to use them. The pin holder is never notified, and from that point o=
n
> >>>> the device and the file silently diverge.
> >>>
> >>> We have the exact same situation when userspace maps anonymous folios=
 into vfio
> >>> and then desides to MADV_DONTNEED the pages. Or any other memory back=
end that is
> >>> used for such purposes.
> >>>
> >>> User space must not zap/punch things that might be pinned elsewhere.
> >>>
> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
> >>>
> >>> I don't see a reason to make userspace (that should not shoot itself =
into the
> >>> foot) a kernel feature it must activate itself to not shoot itself in=
to the foot.
>
> Agreed, for normal use this is userspace's problem. The seal was meant
> for the kernel to cheaply verify at preserve time that nothing was
> punched.
>
> >>
> >> The issue is live update doesn't preserve those background punched
> >> folios and now we have created an UAF attack on the kernel across
> >> kexec if you don't do something about it.
> >>
> >> There was some notion here that with the right sealing flags we could
> >> tell if everything was 'live update compatible' and then know that
> >> these attacks are impossible.
> >Just remember that there was any hole punch and refuse to live update th=
is instance.
> >
> >We could likely implement "we saw hole punch on a pinned folio" as well,=
 but I
> >don't think that's required initially.
>
> If I understand correctly, you mean recording on the memfd that a hole
> punch happened, and refusing the live update if it did? That would work
> and is much cheaper than what we do today, where iommufd walks all the
> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
> is enough or I can record that also on the memfd. I will send patches
> for this.

This entire situation continues to give me the willies.  After much
prodding and contemplating (in my own brain), I got a friendly LLM to
report:

--- begin AI output ---

IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
or khugepaged] checks the old folio=E2=80=99s reference count, so a pin
acquired before that check makes collapse fail.

  The problematic interleaving is:

  1. collapse_file() locks and unmaps the old folio, then passes its
reference-count check (mm/khugepaged.c:2446).
  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
file=E2=80=99s XArray and pins it, without taking the folio lock.
  3. Collapse copies the contents and replaces the old cache entries
with the new huge folio. It does not repeat the reference check or
freeze the old count.
  4. IOAS retains the old physical pages; accesses through the file
use the new folio.

--- end AI output ---

Is this correct?  I haven't personally verified it.  But this whole
pinning-folios-doesn't-keep-them-in-the-mapping situation seems
*extremely* fragile.

--Andy

>
> >
> >No need for more shaky seals.
> >
> >--
> >Cheers,
> >
> >David
>
> Thanks for the feedback,
> Sami
>


--=20
Andy Lutomirski
AMA Capital Management, LLC
