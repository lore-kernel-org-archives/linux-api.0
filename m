Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5DC16415;
	Tue, 28 May 2024 13:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901849; cv=none; b=X8EIAVs9/M9+g6KSlubeoKs9Kp8cxX1rjrJbuDLHuP93RBOX51/EYhO8MloSPql+ck8IhkLtwl6X4OBnoJIE7PFOMbokBG0DsU7NuGAFdvFA2wgE4xg6odPMuZ3Ymol80EwB3X4HC9Q+TKvp0JbfZEERXgdDEJ/y0oDKHlXtHXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901849; c=relaxed/simple;
	bh=8Zq2RcssUire8FNZPbzS6Z1ssADbP43yabaipLHX7n4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXJWE07GNDrsY/wuH4xpZ3vCA1a7xfexhFW6Cs62XX+jc1Hd4xJ+9oDET/PnxLsaN2v5/BtW2Cz6kLkzaWbS9LluxjlKmVEPUelgxvK/2KERRiqMf7e1dg/YXbGNg5YyQ+jXtvcYJYvrRqh5OT30s/g/GN+qoAOOKRIpmyIqW/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Ca+HStlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ca+HStlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D40C3277B;
	Tue, 28 May 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ca+HStlR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1716901845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1YmB/+mC3B7Uuv+X6AR4Yo5wO3pP9OqlModzWLX8Ec=;
	b=Ca+HStlRm1V/6JFjcxqxf6bYbVhsd5cv0gkUathbm3uAT9w+S/HCjHGuwe89z2LVikwECZ
	4crpA5IEWHg00ei99Z5ScF3jV814MiBIxJ9LpFyZf25hzhnc6jT6UifWLrjs1ZtoaNUKFF
	dDPuXV8DMWW5WQQUwBXIiN81T3n5Pn8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0beb4979 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 28 May 2024 13:10:44 +0000 (UTC)
Date: Tue, 28 May 2024 15:10:41 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <dhildenb@redhat.com>
Subject: Re: [PATCH v16 3/5] arch: allocate vgetrandom_alloc() syscall number
Message-ID: <ZlXX0cFl5RANHNOQ@zx2c4.com>
References: <20240528122352.2485958-1-Jason@zx2c4.com>
 <20240528122352.2485958-4-Jason@zx2c4.com>
 <CAMuHMdVJ8KpaqnWeHCMbJdf-Am6uY0N+uFM+OVxWTZH37TQvxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVJ8KpaqnWeHCMbJdf-Am6uY0N+uFM+OVxWTZH37TQvxw@mail.gmail.com>

On Tue, May 28, 2024 at 03:08:00PM +0200, Geert Uytterhoeven wrote:
> Hi Jason,
> 
> On Tue, May 28, 2024 at 2:24 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Add vgetrandom_alloc() as syscall 462 (or 572 on alpha) by adding it to
> > all of the various syscall.tbl and unistd.h files.
> >
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> As of commit ff388fe5c481d39c ("mseal: wire up mseal syscall") in
> v6.10-rc1, 462 is already taken.
> 
> v17 ++ ;-)

Oy! Thanks. I should have thought to rebase on rc1 anyway before posting
this.

Jason
