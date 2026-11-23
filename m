Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448572;
	b=aDnwU+uuCJftvgLt8Bd986nVvkcbAs7lahDUXzqUSjAF9gDVD+jZdjPhdr4/fwrUmJsp
	 WTLsb/oa6f/kYNAbvvPeelruEd8Qx14uN2Np8f32rg8xKEkpu4a1qXICc2D+Ed7FmeaLi
	 KaokcyK4XWXLhaVwKhwU68UJxSbagNGabRxbgSThOSGuRbSAsC3aUUAAkIRRr9aDMNMHC
	 g9oiGnUoZ5/IV8x05yzasP93QeVcymyWWm/GI1gDBaQSyWin6r6FqdlEjKbmEO9sOOq1o
	 wsB/e0tJPy59yDKAtoKgIqzesuhmdPphja5AqRQUMYH0x14r2uROR61y7baK5XrIMDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448572;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=riuuGEnVtTWNXQVF6HXxqh3SkzuRQHjQI696YuiIOXA=;
	b=p+UpaRT03RrkF5fuoYzSFaRZsBvZaGTQT/NtYtUFAKDzZeiC7cHNjn6f2dBSCg/f3C5h
	 kBbvHv4hu5x+ZbxIpJOp5TSfDFoyEWbKciHq6VEgt2KhCahGTvuqFAr45bFYQG4dTGC8J
	 fHhMMKJukz2RzzuNJa4ISjKrogaVZKHRjnJBwNilxZz5axEo7lc3FyAr+9vvzkTw0A6GB
	 BqBMU+TdPWMPUHV6apNL+3g955I/b7/ZqNa0+34W0AZ6uSmED4qPM0sLTsif3zavYxAFy
	 1WO8A24AI75sBNmQNGKD6aaeazXUtJRM/aHowCsblTHcuZcmwgKyjYA61O7eWCZrnig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ce7NZaFf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C6250606A31A;
	Mon, 23 Nov 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ce7NZaFf
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 391B51F000CA;
	Mon, 23 Nov 2026 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448571;
	bh=riuuGEnVtTWNXQVF6HXxqh3SkzuRQHjQI696YuiIOXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ce7NZaFfiDrHnlT5izuCzOYODIzuJKTteA9jXeyOFT5LUGlFOYnDR39EjoSwj1YC/
	 SNWcefv7l/bbO0uX2Nk0ySysJZmE1XD9vs9xCGPNp9v0QeN9q2biKcj+In7T/hlBTN
	 ufzO2vUUHyJ1qKVqH648Y0nCZjYYt9S2zP5gFajYEj67snKrpidJr8WXzwQUxrvDJV
	 2dBtO8GxcLSJoLVLzfhnOuBsLqrD8o66R5ACgm6z2q9CE4K/krQ3Ut7RD2Caa0AVFY
	 iK/j7B0wipcn91RKxoXQm1zvOQI0nW5lfcU2QAAhUV/pY2O88IUdo6lfyYxGxhCGyS
	 ufu9h5uCHHKug==
Date: Mon, 23 Nov 2026 17:42:48 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	zohar@linux.ibm.com, aneesh.kumar@kernel.org, dave.jiang@intel.com,
	nik.borisov@suse.com, sergii.dmytruk@3mdeb.com
Subject: Re: [PATCH RFC v2 9/9] attestation: Add the TDX family implementation
Message-ID: <awRe-A_KeE_kXyPq@kernel.org>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
 <awQCrnD5CtEhKRWz@e129823.arm.com>
 <awQz1P6iXYrL8lv0@kernel.org>
 <20261123151128.GD179082@ziepe.ca>
 <awRYr7yB8IWj7S3G@kernel.org>
 <awRan8ZELzpTwduV@kernel.org>
 <20261123154042.GI179082@ziepe.ca>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123154042.GI179082@ziepe.ca>

On Mon, Nov 23, 2026 at 11:40:42AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 05:24:15PM +0200, Jarkko Sakkinen wrote:
> > > > > As per the function, perhaps tpm2_calc_event_log_size() should be
> > > > > relocated to lib and have non-TPM name like firmware_event_log_size()
> > > > > or something.
> > > > 
> > > > Probably under drivers/attestation since that is where all the TCG
> > > > formatted logs should end up. It should be 'tcg_event_log_size()' or
> > > > something. Maybe a tiny module for it like we would have done in lib/
> > > 
> > > +1 for the name, as it is obviously more accurate prefix.
> > 
> > Location, I don't know. I was thinking something like "lib/tcg.c" with
> > routines that are plain calculations based on TCG/TPM data.
> 
> I think we should not have new users outside attestation subsystem,
> but the legacy onces will still exist obviously..
> 
> IDK either, but this is my guess..

No strong opinions on this; just unpurging my thoughts.

> 
> > And perhaps for tpm_buf (both stack/heap allocatable), if Trenchboot
> > ever moves forward.
> 
> DRTM users will route through attestation subsystem to do their
> extends so the tpm_buf user would be the TPM driver inside
> attestation. We definitely need this for ROT agility.
> 
> We should be able to build the attestation TPM driver without any
> trenchboot stuff to motivate it.

OK, this was my guess but did not know it by fact.

> 
> Jason


Br, Jarkko
