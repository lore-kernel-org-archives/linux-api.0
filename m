Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023977;
	b=JQLeS9HDMlGAIqVPTWOm7MP7tV+Nql21Tf/rBsK24CB1pOL9UUDKdQPkUyLS/Cvuw/gY
	 PbBmt63WnQMe7p4qVWU03tqOKbzx3VroaFspH8uzHJhFafFS84FGQkhdjVCqWpADOP7i7
	 WIc6CJTGNKs4d15VswlLawxqe0hcl8kftXDybzaG1deWZ7bkkPhrFWXnPZORu9ndne6tm
	 u4kBqsSgIA7Y04rOhDLtoh0JoRvphgF3gbhB4aSSiKI4fJc6VMcUn13B5q3j1pG5TPe+R
	 tpB7s7u1JbIOh90vx0/9PTj4QV7te6TYZHWHPexfngFQNFBHOOirNqbq0bGsXezdesw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023977;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
	b=M88GTmQ10hawjagTG/6lbxE6+V1oMRqaN6G3P9tOImsm2bQegjKZA3+V0VE/ts/S70PF
	 JUDeP6Ru8ui/t7otJ8jP9DBOfXsBUmg7rnwwbm3rfJGJxf3GfirprfybCVgyA78zcNpQn
	 tKYWN3y4Aavz29cP4y/E2SnPk0PmBvRTxX8T426ipQjAGj+dZMf2GQu4wTTBYwgmvQk+R
	 j3AJo6rqOeWcKjHLXfcxI7jzkbKTv/31nj5W4Ai9fTBQJhaJY3opnYkRffGarfLfsLsbu
	 K7yS7gvo3RopSJlT3fsogCvlSt1zwsy87WEM5QstqNFgTG2wFxP8xgAqYFjMJL4X71Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="KSkreA/l";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E27606A325
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 17:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0E27606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KSkreA/l
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c14f3dab0cso887916e87.1
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 09:46:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023975; cv=none;
        d=google.com; s=arc-20260327;
        b=Wfhf9ooKXnlbxLFNK88CVuozGnxu8i+Fqm632gRRlcTAN+/imTUfC3omrqRv00LJlB
         8/gE2S2mJ04A429Ro/5zzAqIPzNcJkUOo4ilRkdNrx0cG7VkKJ1S4iAfT0QyjZs2Q1ZT
         x36+rxALSMj8NHJbQb2quQy0bnwla9V9K5x6uVhQX9KzzfUoIx3v92gHqG6RHbNVTCCG
         XPBBZwud7JKt29H4VoCvIzru9Xgxc1wlNoSFeRGi1fpO2ltd9u7/wJt35iiIA5MQsKWa
         cVSAyu3U1iZ21eDa9U9mgZjrrw8z4uFo+qi7Z4FzJEqpajqLZ3T7j5OtdZiDs1XBm7yz
         zDWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
        fh=AnEs8DMqbpDMi60NsMNgIjvZJx05njfOHPpskRVV6oE=;
        b=PpEKbptGOjv+BHXwc6NeWLnpxdYAbP8si1x/R4MQgrznNkCqUKlwyEyZl1/yQEZ3fn
         r33yKPK/f1gB1/B4jzmf4gm0FintfQwZOeCCREdTT4OQF3onwcgPV7ID1CZK9pEiI1Di
         uznN+/4806B1mafNXzn9vkOoJV8Rkt2RAi9PPZoAKNY+gsXw78pHmpEGaOeg7qapHFpi
         SffMElYRSQSdVFJQmplAwGXFN3soElvTldYfq+sB5MjtdUSBupwy9l/izpN14aIKh0jQ
         uGYkRWx54tbWnsYP3/oB7xqaCTbTddW+PZRNPuSzgbKFzCZXIJKhYy5w4PP6U8+VdUsi
         l+sQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795023975; x=1795628775; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
        b=KSkreA/lv4ezsG6FIG+0z6ugqaPZfz/K227G/b9zqB4WbfNBD3XL8nHiuC3RHSDVop
         r5WQO1yWZkBKMg+zBj6fpTWLOgpJt9bMFVDdhzBzxpnWtkhvlsv4/E5kXo+obO4szmr+
         nFnhBGrEd0bPzAozYpmaEhgJtA45FnEzG5/HZEZEyKNuYbIbPoPWq9RPDZYH3gY4NHNi
         I3IElP7vq/+9MvKb/InmOXdTWMpefUYfbAAhC3j8k1680QGt9U/5fB8JA17w2EOZ287i
         CuVr1tTToajDP4e2jNTAGYhUjIUDF7CvDim1WkQKv5tAZUDy/kdf5WduxQLtE+TgPH5v
         7k/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023975; x=1795628775;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SIiWqHkbikiw9/PSo57TK7nq7ydcL7CNJ2g4TYGph1w=;
        b=auV6mcCfflJs7bHPytDzn4M1i0KxN8v+146IJJues1ZrVYoL98AyBrExX+dq5jli0W
         QNMQe/95BSMqpzJMYXNqepZDqQ0nR0T1TI+zDjU8yH31Nuj44UJwXfWT6LL4t6HtG9CD
         0z/FbHKq/tKokPj9lTnyWaNfxkEuBxEW3sYJwbUc7OnYwBvGNnlojFvT8NXxJeBCbnR2
         Ai4HUURh3/nsgt3D6WHrM7227HPInm6Tq6r+cRdcoIDEoAwz0MzDUpVA6KsW0HABCein
         F2SG8ySK3oLbyBSVbQXhr71+Nyz4QVcx2/K7X3T7e9lZGWDPMKw2bwhZ9Lfh0/WucVx0
         njbQ==
X-Forwarded-Encrypted: i=1; AL+hErFIRRFRkuM9ZyBEOijtoQzYtw1S2bvw/ueDP9YZe/ooTRjKnN+VP1cXyenpXFMA+QgUr4Lx0hBNVp4=@vger.kernel.org
X-Gm-Message-State: APuU4Z8X0vSxzhbpncWtioPhRgjPt01qmIFFX8xtXDHWmnYXOnT8F+SA
	LfK2kh1z0E1jVfstzOUEruiffJXfsG03F+bKXsEV+sQV65gcJnSrM9X1q5KIDUF8k+hQgO+uhmq
	yhE//W8cGoNWfn/HW9Ok9YoixGA+gwI2DWTHBD4TX
X-Gm-Gg: AYBFou1YUzg1kwOKvkugm4WxaqHaW4YImGexaHftO1b04wgRfnKoTJgk1HMtdpKH8R9
	+0I6tvua11sIUpkE7YNzetBa9kQpVu10aVp9655HhCagJfTWpG9AeB+G+4ulkheaXERymdI53Ar
	vUgBDBDlwI+Vz7FYWGHB823fy9yNSIEDDp8GByARIwp2WkkBwhBn4z9Uo4v2/smHZE79NcGV9hF
	olF3CbsOUuTjw/jxOLMGUEJYt93iQJAILsXlLIi9utrHS3XgZ7z8VHZ1db66yWAcUfJ/S3O4yoQ
	r36ai072D+QxF7dHn4Fgez4p0N7+o6thpltUoqZdo2h+1RRCXCTKxgDezRsnlufhlUo5dL2WWG6
	SJiNNT+UIE2LslIzlGk8UMph5iuKz0xLwxQ==
X-Received: by 2002:a05:6512:8346:b0:5c1:ac84:c105 with SMTP id
 2adb3069b0e04-5c1ac84c2a0mr745576e87.57.1795023975125; Wed, 18 Nov 2026
 09:46:15 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117231352.3816603-1-jarkko@kernel.org> <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org> <av3bkDnwmjunTleX@kernel.org>
In-Reply-To: <av3bkDnwmjunTleX@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Nov 2026 09:46:02 -0800
X-Gm-Features: Aa3M54rqJXQt69c6byOctTWRaXx3nXcFQskBrnHvxsTyM3qw4EOZDCkVbvK6iJk
Message-ID: <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
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

On Wed, Nov 18, 2026 at 9:08=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > > On Tue, Nov 17, 2026 at 3:14=E2=80=AFPM Jarkko Sakkinen <jarkko@kerne=
l.org> wrote:
> > > >
> > > > OVERVIEW
> > > > =3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > A root namespace (rootns) is a kernel object backed by a file descr=
iptor
> > > > that binds together:
> > > >
> > > > 1. A full or partial set of detached namespaces.
> > > > 2. A dedicated PID namespace for spawning processes into, signaling
> > > >    members, and polling or waiting on PID 1 exit.
> > > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must=
 be
> > > >    populated before going live, without inheriting host mount-tree
> > > >    ancestors.
> > > >
> > > > Work on this feature started in 2025 from David Howells' container =
object
> > > > patch set [1], which I turned into a namespace for namespace roots =
and
> > > > rebuilt around that premise.
> > > >
> > > > While the patch set is manually written, the original motivation ca=
me
> > > > from isolating LLM agents. Running untrusted agent workloads made i=
t
> > > > clear that OCI runtimes need to minimize their live configuration
> > > > surface.
> > > >
> > > > Assembling mounts, credentials, and namespaces inside helper proces=
ses
> > > > with a half-configured container is what I see as the main challeng=
e,
> > > > and the existential debate around namespaces and container objects =
is an
> > > > unfocused discussion topic.
> > >
> > >
> > > I've skimmed some of the series, and I see a bunch of good ideas that
> > > involve using an fd to manage a thing.  But I'm wondering how much of
> > > the value is added by that and how much is added by having a new
> > > *type* of thing: the "rootns".
> > >
> > > How much of the value comes from the rootns vs the new APIs to
> > > configure namespaces without entering them first?
> > >
> > > For that matter, the cells series also seems to contain a (possibly
> > > very similar) variant of the same thing.
> > >
> > > Would it make sense to come up with a patchset that does *just* the
> > > configure-a-namespace-by-fd part?  It seems to me that this should be
> > > an easier thing to agree on, and it's a big part of the complexity of
> > > all of this, and it solves a real problem even without
> > > cells/rootnses/jails/whatever.
> >
> > Is it  more accurately scope the part that is "just the fd-part" and
> > what you consider as "extra cruft"?

I'm not actually trying to say that anything is "extra cruft".  What I
mean is: there seems to be somewhat of a core that is pretty similar
between the two patchsets, and that core seems independently useful.

> >
> > I.e., where do you draw the border?
>
> I'm asking this because I had similar thoughts when I started this back
> in 2025. David had some good ideas but it did more than having a fd
> that does not go live before everything is set up properly.

I don't know that I have a very clear border, but here's an example:

rootns has MOVE_MOUNT_T_ROOTNS_ROOT.

cells has:

+What else goes into the tree is mounted on it before it becomes a
mount namespace.  A
+filesystem for the cell to write to is mapped in the same way:
+
+.. code-block:: c
+
+   fs =3D fsopen("tmpfs", 0);
+   fsconfig(fs, FSCONFIG_SET_STRING, "mode", "1777", 0);
+   fsconfig(fs, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
+   mnt =3D fsmount(fs, 0, MOUNT_ATTR_NOSUID | MOUNT_ATTR_NODEV);
+   mount_setattr(mnt, "", AT_EMPTY_PATH, &attr, sizeof(attr));
+   move_mount(mnt, "", tree, "tmp", MOVE_MOUNT_F_EMPTY_PATH);

(Source: https://lore.kernel.org/all/20261105-b4-cells-v3-2-bc9095937a84@to=
xicpanda.com/)

I feel like you are both *so close* to something that would stand
alone and make perfect sense.  I also feel like, if that's a goal,
then both series are slightly off from the bulls-eye.  (Keep in mind
that I've spend a total of about ten minutes looking at the relevant
parts of the series.)

If I've understood the two series correctly, and if I'm thinking of
these abilities as something that can stand alone, then I see the
following things that I'd improve.

rootns: Why can't I use a *mountns* fd to so the configuration?  Maybe
I'm misunderstanding something.

cells: The dance where I create an anonymous mountns, mount stuff into
it, and then attach it to the cell is cute.  But I think the userns
interaction is wrong: you are making me assemble all the mounts in
*my* userns and then clone the entire tree into a fresh, non-anonymous
mountns bound to the current userns.  And that clone operation is not
free and serves no actual practical purpose.

Why can't there be some variant of these where I can either create an
anonymous mount tree that is genuinely unbound from a userns or that
lives in *the target userns* or that *is already the final mountns*,
using just mount-related APIs?  In pseudocode:

int mountns_control_fd =3D create_mountns(either userns-free or with a
userns_control_fd);
fsopen, move_mount, , open_tree, etc;

Finally:

cells: I find it *incredibly annoying* that one generally cannot put
new mounts into an existing container using most existing container
managers.  I hit this on a surprisingly regular basis.  You seem to be
baking this into the whole cells design.  Why?

both of you: Can we please make it possible to do the parts of this
that oughtn't require privilege without privilege?  If the cap_userns
thing ever lands, cap_userns & CAP_SYS_ADMIN ought to be more than
sufficient to permit creating fresh mounts even without creating a
userns as long as we don't do anything that affects privileges within
our own userns.  Or let us create a userns, *not enter it*, and do all
the mounting without actually having CAP_SYS_ADMIN in the permitted
set.


--=20
Andy Lutomirski
AMA Capital Management, LLC
