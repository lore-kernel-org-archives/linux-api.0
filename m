Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793054818;
	b=GyK0VM7nVnU8VzVQScmChzyuRkKA5EzEPZhVfYNAVnQHD1SzY+e4+CG6tzs+WVWt6yNi
	 kZehU9Jr6a0/7WyBXNeEsPOe56J8SMZoDil8A+oYr7876GW3hOKNznqITcmiI3levTDm/
	 EaAJwR19WWz/lvbjNpByOKhn934zduEh+KM6MfHNkf/4EIZrQe7Izd1+om7cEAuwO+n3K
	 +0EtE+RakPX5+Vl3pawdk+tDNrj5xAXte1PjCLk5oAIKcmX2bdBU5+39sSyMdlsFaCrBU
	 ipf6Y1CJX9SzxIAqrcxN7qiw3N8re7qTwZakd/X8bscFjx5LBnLIgpK07q6sFjcByoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793054818;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
	b=RWJXBS6DG9+X67EuuX3sKn37gsY621We5u2vQ7TCsSJ1yKseFTwXp9Ys13gzcDvp/sv7
	 FIlviBJyYx0xi8de+rRjahSbIceuGD5/BzzrFw4bhwofWyEsusMSrZqbC68SjDUs30a9b
	 g4hXjKGI/HSgjgywRiQglmUosuwMpuqBfSbyu6eScMCkCV5ZdyqSljYOn0aXfJkvvOc4u
	 23fmMYO6dqXK5gH6jIh9yehnBfXnOXtI6ujpiPBUHDzYYcWv+WBfe4Ex8uIMwvmpDRE1W
	 mo5wG9xruZ+l7P8YXRciy1PWHLWe711yq/+T4EC5J6qZg6DzCh8t1vurySQAbw8S8nQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6D606A31F
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 22:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47F6D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcc6094d7fso2766050e87.2
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 15:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793054806; cv=none;
        d=google.com; s=arc-20260327;
        b=i7V5mftoamVLsPJnkM04bSe8Mw/94nt53nRBs5WdPWUeycIRxWhphIl34HSVrgENr0
         j0duJJ0Zxd0fpt5Z0ModmL5/nxBKoB9j5yPz2JeUiorOHPH22KxKhJExd6TVL1YSZGlN
         xZJQZClK711dqdCMVwkMz/Yy9EyYt5CDtLZbU20peH+WwjRw1Y3rLc/+z+m3Pm8l5D09
         euxXtLAdv/2vASYCrMASOaWm4dnw2GhjZKKghrNqipUbQwlcViNGMEm1dDhZnORmpMB1
         yTLtjMb1tQb1Uub3W0oB5cjc/2L/akiEmZYxoUBDMlxc5LQUET4rPOxJdkBATrk6wB/7
         BUVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
        fh=Wdn/+sZTOmC91NeY9ixY1eTg4nn9ClRABcuyehYvrPk=;
        b=q+GS920B/thSiaSEdd0O/UEMVyFEEsAuz6agSsHjZBwZFbYhxfTK8PRpVhi4FwQ5mF
         yFcQIDIRR/mmwCAZ1HzRA+tBKInXQPzZ1EoF1GMcKl/cOztjsKi2yfV9M3OGaPlb9ajy
         AdipmQBCwtyT7ZTtNeGYuGQQb5BvcgYsnTRsn6fjscdKVMZ0eijrdbYnIkcKBeDyxfu9
         ymSeOXRMBYWgIqbIosKf9Vee+EoHLLsjt0gyYHrQCDLM/MIqpamNScJod/jcaPMBfSRs
         MFJYGyPI5wk4SZv40Lwc54DtjWG6MXq4PljwhItVv6UIUX1y981vH5haUFfOisS++SkD
         a5Gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1793054806; x=1793659606; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
        b=IOFsVvG3NSAD3HQiNhWpL3xOBWeFRtR3M7DeFYRGlG9024CAVL0BclZq+S6ghRSIWE
         E0Kt3NMTpMvEFh9m8yx+vpnYuCtqzZQ28yrkGkOHmwbJ+OS/FnBciKMvh34M+kcoCCOl
         Z2Ecmb6YILV0KENHnULJ6ha+jfnuhTE9OmQOtmZ4JYXTLGs8Ff0itsup6BKnrxJgen/W
         L8r30Qn2tTTSYPH+0TiIunxBTdq1zvhjrLsS3Hp9Fc6rUz+0kj+oXRMP1K7i4huM3ZrC
         CXMi12Rhds0KfLfi2+y10IxrDw+vVJgAyThh0UFHJXCkL+0SIlxgIVMgZv1LIlbPYKCO
         87Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054806; x=1793659606;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
        b=aiihc5eSQwAhpvvj7qRA58Rf9Qw9Xg0f7RNjS9wkFb2zYA9LcKQ7SbYo20/YHzvcmp
         UncbxMaEPbOTL+RjVNIRHNkxX/ouCxYe+Ya8Y9caxDNEWtH/dhSFRLcVmZbRMvA99viB
         qA+BXqnx84H2sG4r517Wc2bEabdjBVqj9pSzuAk2P6m09bTpCG3PHj8cBPZAnXmuV+ul
         0FUum+tEUmVtdK+YlnCjDLMlo5/9JD+mMR8QfpRNv8xQurh2s/PYxrbCGclcVPpReNlp
         Cr+qDgXeFHvCreeVABMgPUsio0QHKlQ8I1LPzUmNYGums6ilu5OKLnSzhV/JB8LiQa84
         MOdw==
X-Forwarded-Encrypted: i=1; AKwUvBwEOTuDUxBxGxKGnb/sVPVUJOpjabbCWdX88dmcJdsB1EKrElrIz463VbpltOfHP3pmQ88adEbn4vs=@vger.kernel.org
X-Gm-Message-State: AFq9FYLXstInyTeXf5wAMXMyboD7Bj0iX/2EtvSS1ZFWFpvyCfJ5r8qh
	oALyx6ID5G4w9+CZEkwJDmTBfPH7stA0E+upN0SigDD/5sBhdOpRBRHMxSaWcw3HOc2ssj8pyrM
	IoK8prk4LVwakFjvyTDtFcrlLwwbkJutyngN4xTXO
X-Gm-Gg: AYBFou1JLR0/C+uCOAglC4beRMEo9hyRhp2q/0Zpr0wHbWalRrWsbn2+xVDQ3W+JjN/
	Ihpk8dniNQcTcBCtOS858geCLXrZD4OTKr8tjMoCaf94Hq58+qDhdnhIHId53y+xMeRi5QfTvPm
	qltcyeSKn00xyDNKH10kpMyo9GvWfqW5TPyjW3jFC6iPbykOMqTOx45VaYbTua9OeuBtVP2/iJI
	pHqGspKGL2VPrMg/ure6dlkLDdavf7LhVB0DoiTRw9AgaBRyJILtJCDDIa/dbqHEAhQUtuMGsPQ
	iX82jHK0eGRcQO+7uHA7XBBE3RGz8hjyXgtNcxbKq+ty+HIgVUbn0n8AKALS1NH+gWY+6fwkYs/
	8NIl3nRdhRV1tCMEGMm3CKTMQFLQ3ogK56w==
X-Received: by 2002:a05:6512:3e0d:b0:5bc:e28c:1349 with SMTP id
 2adb3069b0e04-5bfb71fd555mr2854881e87.56.1793054806319; Mon, 26 Oct 2026
 15:46:46 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com>
In-Reply-To: <20261026220546.3114241-1-skhawaja@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 Oct 2026 15:46:34 -0700
X-Gm-Features: AclHuK_ddIvC0f7JBYWchwOFfRRqT-a0AZ_RsWY_MxD_DGe6_YpRsBjkP2gzVDw
Message-ID: <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 3:06=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
> holes from being punched into a shmem or hugetlbfs memfd while leaving
> the file fully writable.
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
> device for DMA. Pinning keeps those folios allocated, but it does not
> keep them in the file. If userspace later calls
> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
> the folios are dropped from the page cache while the device continues
> to use them. The pin holder is never notified, and from that point on
> the device and the file silently diverge.
>
> The existing seals only partially address this. F_SEAL_SHRINK prevents
> pages from being dropped by truncation, which is why udmabuf requires
> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
> them unusable for memory that must stay writable, such as guest RAM or
> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
>
> Proposal
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
> -EPERM, while reads, writes and resizing are unaffected. Combined with
> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
> the memfd while the memfd remains writable.

How does this solve the problem?  F_SEAL is about a userspace
contract, and if there are existing users of the APIs in question, it
makes very little sense to start making those users fail because they
haven't taken the appropriate seal.

Would it make more sense for the drivers in question to set some flag
(refcount?) on the file to block hole punching?  Or perhaps to have
the hole punch code notice that it's trying to punch out a folio that
is pinned or otherwise referenced and to refuse to do it?

To some extent, the issue you're describing is maybe broader than just
the APIs you're contemplating.  If I open a file and then do something
in thread A that GUP's the file and punch a hole in the file in thread
B, I'm doing something weird, and I can imagine plenty of ways it
could go wrong.  (Especially if it's GUP for write.  I hope we already
get that case right.)

--=20
Andy Lutomirski
AMA Capital Management, LLC
