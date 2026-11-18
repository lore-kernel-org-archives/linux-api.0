Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795021194;
	b=E7/wU1JhbrjAkNcyUADF9wtoSfqviGyejrjq9gg8ZRkRQdD2+Gp9Hug5q6iVY94XkT1+
	 V937urDPHtgDZ+1L1Mbr259/OtQg7hsHAErmVU3MCiB5C3TOAjF0Dkhqka6udvCrmMRTz
	 5l+sbb+9dR3HyXSbYT+emCMEFoXnBswIIgQV+G3+dcXprFi2O2n0nAXAV1/j6Ws8IEOv4
	 N8WcKEN251OodJYdy7QK1YFUYxFyrMVfvW+MIU+uPZC8I2LAKLipoZPWdWjWIk2912sKf
	 TUyR02mxEvWsQFYJz11zCguXeeRpvPahIlYMjaElEuc164qh4a0bDDS7v9Uq1CtItiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
	b=vdW8whV6S5gpDKUOpn5Ej5w2RSduvHRsh1vKGE8Mf5lVBCeZ3b5pPc1uLeTaQYbh0FPe
	 eAwrsHpYmpg6ELbYCbE7VHCzStrnXfGxoU1ej2L3B10CefGcpXoU+XHdEOSO0H82LgNQu
	 lx6SOGl7/OVEto7oPHO8OoLru2ZcfgoDDCNgYrvEpCwXAjcnp3OcUVSSXwqfYTBahBQM5
	 Gs7UTQZVIimZ43BQBeH4qSLQ+E6nWa7LgFI1McwFxpQn8antOjrWS9P4mapCNXHgsvIkJ
	 sM1bx8RflZGlkViXiHZs1Bhwm3R8PItPRaXq4rpRlHPbwaKB/vaUwrIHtdXecQDVhrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="tsb3jtv/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA63606A331
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 16:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AA63606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tsb3jtv/
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c14f7768acso896103e87.3
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 08:59:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795021192; cv=none;
        d=google.com; s=arc-20260327;
        b=rahW/IyK1OtiukoIpJvE/n/tkFgazhfeH2bGei1HPaPAA9gjG2x53C59Q0rGTgXIUz
         v1XSAKKKLr4lsXF9nRTkvxNa+TR7lsbIOt4KPzJ1rzPoO6P1blObpjH5W1QolyfTuB+7
         /j1cqcGGO2lOZ1WtF+ig3KpqavOOtfHYkBclY4CygfMpY0uNgkybIbr+YYTqs0dtzQSr
         pAxYlKydd7HgHdJsesp7mJXzJkF5YIs0yWNcTB3VZSd7no0PIustF9X4kiO7Xm0woyVY
         7bfXYdB0Kwg0+1G9w5SqUFilB0+oo2jCILsgXVXrUDq5vsil5yXbE7GICC/x1eUDP/Bd
         zCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
        fh=gLeOfzhudHt9yuDN2fXQ2C5T9/vInYIVTmcBgLv/UfM=;
        b=oKpFre4OMksi6M0i8KhFk0cFbwfqMOJx8v+CuGEBXclTGsteCZz7xi0cPzyxGab4q5
         qDa7ZdxOYhSb2g9qXGpqCOjwS046a4TClZQcX8qQ4tvg9UwsiBd1+Pe2nMeog2HsGIEQ
         aCPnxLdtNPYcY7E0JW8gKqRqdkwkTYhV+vqly/chmpxsKWQ/PjVZQDDAj2jUudiFGQVg
         R/ToFc+3JLrJJAA85QFXGa3qt8Y/m7WFrQTI0bkxIj9lziMwBvIGophb5ZAtMx8gN3GX
         T7JRVwuGEim1rh0eRm76lEMhSSeN+0hPcY7is9YTv/DoT6Ofaw2YUEz2HjfUJ9PUZ1lD
         zMxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795021192; x=1795625992; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
        b=tsb3jtv/d+zI1r94mKuk01oFSXaGJ5VfBd68Dm3Rzy3k/9SLJEJI9zvC5ERx83P8mh
         L/1k5WahXt+pRRzhHcYHDMSRuJM1TjD5VHtPSmgdvcsE7bgjMsIlMo+YJOsxodt6BDKE
         WgZi0KNeAOjP6r2GiyTfd+fHBUESbduG4DYdClB/Bqst6T6AYc3Y24sbaheI8lu+qMGX
         3hhYwGZJIpgbaepiYwepZXr+V9cZ/bQz35fnXnkTNzQzPv5ISz2zAb8tKPjJ5JQ0vFBn
         iosrC4gHAY/nVJ74V0i+yTKb1wxgWpU8SzcVufvUcALVry0duvdDvm8V8jy8r4h1xcDj
         iTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021192; x=1795625992;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
        b=Z2YFaucMcIjXNg+2JMQqOwMyOm9B1LWM1j5r5J+EI6OuZU+Ji51puuCzVoWRRm8MnF
         DkYtYN4G22pi1gFAlzc6EoXbkM9NOQRwL8coEiYY/MqsfhC7Rxck7zYLGbfTjxL7u8O0
         mn9fFjqcjj2RzkuzrPV/Q6EK/vB/EoW8E/MmGzGZTS27Mkj248g6VRWJat0Q7UsICpny
         +ztrAxLTCv+ZNt00X+a/YfsfGma7gqbV8XWpPuyfVhZ7JgL05JZFsjMt+GiMN1gsD0ft
         N5W5KMIMDJBro+2SOT1WMICBZ9ZJ2qSSM9z9BZWqDx862oQtsc8sE+VAIB991AYYRhda
         aRWw==
X-Forwarded-Encrypted: i=1; AL+hErE5ssYi5a8Z70jlUvv+jEAr24ZmBMZIVkikGTs4HX0P53njMprtYY1EpD40E8D/kjg8gDW7q18AnbQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9EYcfaASJYOr7wkStFjtmOKnRk3LDE9b7eIvXRyMGEkgqEnp/e
	EEM3PkV+M3FwXK6Pl/EyUCS9HJ23Tf5d83uTPJUKH/taDaREsSuztt01neo/ke5GYfk5xZ+i4AE
	uYahd5n/4jfHim1Sxy7OgcwnqkyW0teq+MYC4njrV
X-Gm-Gg: AYBFou0IWxhdkeKAVHQrisUMLOmRBImgFE5Z4jDi2/wTsTVckJWaqNjo+8gGs4jNWri
	D1EMwLVxe+NOrj4TCCXA5qCx1tXRNd89VbvuX3Dq8QxMXft52CFz3QW+ykiYyCoxfnprZovy61m
	tMiAs4vh2x+fT7+jGaSFixb/WdwH/QVg9jgYwcnxnUk0l5aRViRaGvrdaQD2WmzjvOlNCUpSZdC
	dlPSPLjwzqVbBtZxTLOkhhpJcic4Q5hGi2oHu3DUfYwlQWv6tlJykIaYh/WPP3wLxZOqpcsZPYD
	pkMiQPr4TYddi6CP6KjiNbPngiWFp+o7GVAo/riVu2cDUJqKHjWrmWpHzyF8G8xh2B6meXkI7YH
	iOBLyAH1X57/DOawzPn8KzdWMFx9Gx/U4pw==
X-Received: by 2002:a05:6512:318a:b0:5c1:4e41:3cdf with SMTP id
 2adb3069b0e04-5c1a9c09ccemr1012943e87.12.1795021192313; Wed, 18 Nov 2026
 08:59:52 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117231352.3816603-1-jarkko@kernel.org>
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Nov 2026 08:59:39 -0800
X-Gm-Features: Aa3M54p70wvOKpegO09-C-J-9l2I7cJO4B_J5hynU_tjApdK664yCTjVeFp42MQ
Message-ID: <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>, josef@toxicpanda.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	John Johansen <john.johansen@canonical.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Kees Cook <kees@kernel.org>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 3:14=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> OVERVIEW
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> A root namespace (rootns) is a kernel object backed by a file descriptor
> that binds together:
>
> 1. A full or partial set of detached namespaces.
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
>    populated before going live, without inheriting host mount-tree
>    ancestors.
>
> Work on this feature started in 2025 from David Howells' container object
> patch set [1], which I turned into a namespace for namespace roots and
> rebuilt around that premise.
>
> While the patch set is manually written, the original motivation came
> from isolating LLM agents. Running untrusted agent workloads made it
> clear that OCI runtimes need to minimize their live configuration
> surface.
>
> Assembling mounts, credentials, and namespaces inside helper processes
> with a half-configured container is what I see as the main challenge,
> and the existential debate around namespaces and container objects is an
> unfocused discussion topic.


I've skimmed some of the series, and I see a bunch of good ideas that
involve using an fd to manage a thing.  But I'm wondering how much of
the value is added by that and how much is added by having a new
*type* of thing: the "rootns".

How much of the value comes from the rootns vs the new APIs to
configure namespaces without entering them first?

For that matter, the cells series also seems to contain a (possibly
very similar) variant of the same thing.

Would it make sense to come up with a patchset that does *just* the
configure-a-namespace-by-fd part?  It seems to me that this should be
an easier thing to agree on, and it's a big part of the complexity of
all of this, and it solves a real problem even without
cells/rootnses/jails/whatever.

--Andy
