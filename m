Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8AC4E0B73
	for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790010012; cv=none; b=gh1d6nGETvJrdFfkdiS5cHThsjV7+sen4Zr35SCrYTWzAz5wUsLoVXIyzz2RANZDpjbpozKpK5dRTKp4go+03svUOMbs5wdW1RCdEIYwzWyTND1QMd+p+ZWgK9fcGOSWwRgkTgGfdz0Xk3iGFTBx+rv4PHZZTkt+CGnaGhGpCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790010012; c=relaxed/simple;
	bh=hK+61oik5gsxN96IHn3CnokMCdTIaajwpmg47B7x+JA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Krhg1NOxw7b/CvfhjwUQkn7e7FansXD5HXcLPf3IvN10DXV8WJR1zigIImgbjQobz5EBK3eO9j4jigLZ0IY2XYdiA0civaCd2LciH1czwqkR0xkC0Ba81gzuPplhsXQxkeTGWLvN6A2pVjh+aC0Da3zDzMkkNgDTzI4z9WWXZM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f16f15so3411045e87.3
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 10:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790010008; x=1790614808;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hK+61oik5gsxN96IHn3CnokMCdTIaajwpmg47B7x+JA=;
        b=Ytb7x0B/EBbQxzDFoVG4JxLi+SvyMqRGHpSYrRtxfEGI9iutJcPzyxYnfX0ROz9dfx
         j7oI1Ibf3bXenrxD5QRbnJjbeclfF4SDFjNXmCjmCypwsvr/f6BkYaH/8WXabLGxkjaz
         3OSGdfixEsySZr2Aa2sFJP/XfKayxqQwKjqPC2DaBxRCP3Q2aAOPovHvAU438OYtQT6v
         cRN37F7JYEvC6wGNgU4yu5PsHftfRRgJZW4bw1qdjKdGxW3/lvm4uMomMeeZijMEoL8S
         dTpp++bX+Gilq9c6kH8a26Lys+SjgLkhPnDtIQTONjfgUGPFX9iU/eicroHcyk7TBmVw
         nbWw==
X-Forwarded-Encrypted: i=1; AKwUvByaDL6DJx7FBj6BLzjJ5FI2VTlBUBNw23gUUpUqg+HmF3neZ0P3WRwC2Orw9hU3HkEeThKsmdDMnZo=@vger.kernel.org
X-Gm-Message-State: AFuF++kKUqmVDb6DPNRqm34M3ScjKBbQCRA/z45VIm2jVCN0WrH9nfVY
	2Llfj2U3r/Izj0YNQxsPCg2d2YtgzyaG8HzUzWAHtlDJ8Dg3WJz6uCJwyuJH1+f2Z4N3FA==
X-Gm-Gg: AYBFou2B6SGh5AEvGk3AyuxPqKa71ZtSzcUNaMnQ55gCC9fWc15D7BEDbEFtR2r8ui+
	fbQ2zOqgfEE9jSPzXooxHLcn7E2pRjfApUUyeOyIwN6GvzfDZKglTHS6uOKtZwy/A+DZ2avwvAK
	709twmWg+icXcP9zYuleKCeyGJ+mBngDCH61kPXPW3TQzt+0G3Zwh0TlV2wyvNksoQeajmLmIvc
	aUakyKuwxo0XLSji6l5z80syJC3maOeIw6MhOmklftrzbwUz8UCzkRsPBpDmZxIw/noGglxz4QB
	TBk22fXLlKjtpi1R9kuJ/iFfwe4T2il6tfme3FAZltz+WKLfZWLaYzwkBCaQ0OT7hv6+7EgTaTS
	8Kq9ORJRoCpY23NgHQhz1Xsy+VozJK24feT0j+Dle1EglDwhhGMkQEdSQYt4wcHL2mYMBJy3wMG
	wh+C4TJUmLqdp/qAfTkBBcwG8f0SlANMS2EDNz63EaQdlDo6uXRs0leGn0kz0D8O7pcen3khktB
	wB4smqVjEtH81lhgltgU1hEqoQ5iWhKomMfHl5+XB/lWHNUvyRuUtjYo0WgTtrz
X-Received: by 2002:a05:6512:4023:b0:5b8:bc5e:d10e with SMTP id 2adb3069b0e04-5b8c1973168mr4013613e87.56.1790010008152;
        Mon, 21 Sep 2026 10:00:08 -0700 (PDT)
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com. [74.125.229.205])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8c795ce7csm2151222e87.62.2026.09.21.10.00.07
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 10:00:08 -0700 (PDT)
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8c1b8d7b5so2492346e87.0
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 10:00:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx9mUUCdzkeRmXE7CejwCAwn/76txc/2XgP8qoAcRcCFYMhz2yXg990fb6CeykRGccdMrOk3VLG5wo=@vger.kernel.org
X-Received: by 2002:ac2:4c4e:0:b0:5ad:55f6:1ec3 with SMTP id
 2adb3069b0e04-5b8c181f45bmr3718755e87.5.1790009663874; Mon, 21 Sep 2026
 09:54:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <lhuecf9cbl8.fsf@oldenburg.str.redhat.com> <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
In-Reply-To: <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Tue, 22 Sep 2026 00:54:11 +0800
X-Gmail-Original-Message-ID: <CAC1kPDMCFoVsPDZgoCF6mHqHQafCkDc3Pohpp6pNOLJzE2OTYg@mail.gmail.com>
X-Gm-Features: AcwNN1U1zJ5xAFsdo7eYagPVPgcyEU2aovVJcIoR_uPclCIazBY4PYSmw97k5Co
Message-ID: <CAC1kPDMCFoVsPDZgoCF6mHqHQafCkDc3Pohpp6pNOLJzE2OTYg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Chen Linxuan <me@black-desk.cn>, Jann Horn <jannh@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, 
	Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jann,

Christian suggested adding you to the discussion on this series.
I sent a follow-up reply with you, but I=E2=80=99m not sure whether it
reached you.

When you have a chance, could you please take a look at the thread and
let me know if you have any concerns?

Thanks,
Chen Linxuan
