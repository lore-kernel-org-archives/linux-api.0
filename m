Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A36C4338F
	for <linux-api@archiver.kernel.org>; Tue, 27 Jul 2021 12:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CC8D6124D
	for <linux-api@archiver.kernel.org>; Tue, 27 Jul 2021 12:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhG0MBg (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:01:36 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58336 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbhG0MBg (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 27 Jul 2021 08:01:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6BBB41C0B76; Tue, 27 Jul 2021 14:01:35 +0200 (CEST)
Date:   Tue, 27 Jul 2021 14:01:35 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     David Hildenbrand <david@redhat.com>
Cc:     Michal Hocko <mhocko@suse.com>, Evan Green <evgreen@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Shi <alexs@kernel.org>,
        Alistair Popple <apopple@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2] mm: Enable suspend-only swap spaces
Message-ID: <20210727120135.GA32265@duo.ucw.cz>
References: <20210709105012.v2.1.I09866d90c6de14f21223a03e9e6a31f8a02ecbaf@changeid>
 <YOvpVRSMJe8NQuS2@dhcp22.suse.cz>
 <30dddfb1-388c-a593-0987-73e821216da9@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <30dddfb1-388c-a593-0987-73e821216da9@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Could you expand some more on why a strict exclusion is really
> > necessary? I do understand that one might not want to have swap storage
> > available all the time but considering that swapon is really a light
> > operation so something like the following should be a reasonable
> > workaround, no?
> > 	swapon storage/file
> > 	s2disk
> > 	swapoff storage
>=20
> I'm certainly not a hibernation expert, but I'd guess this can also be
> triggered by HW events, so from the kernel and not only from user space
> where your workaround would apply.

I should know about hibernation, and I'm not aware of any case where
we do hibernation from kernel. Userspace should be always involved.

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYP/1nwAKCRAw5/Bqldv6
8pHjAJ44gAydZJxSbawcNsnD0Vx7XPnYNQCeOFPhMYsWI6XozIkeaEayJDVpRxc=
=XzQI
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
