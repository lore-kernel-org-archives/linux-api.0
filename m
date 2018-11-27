From: William Kucharski <william.kucharski@oracle.com>
Subject: Re: [RFC PATCH 3/3] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Tue, 27 Nov 2018 10:06:50 -0700
Message-ID: <5CB5F808-ECA8-4A4E-B942-7D69522E3FA4@oracle.com>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-4-mhocko@kernel.org>
 <0ACDD94B-75AD-4DD0-B2E3-32C0EDFBAA5E@oracle.com>
 <20181127131707.GW12455@dhcp22.suse.cz>
 <04647F77-FE93-4A8E-90C1-4245709B88A5@oracle.com>
 <283f38d9-1142-60b6-0b84-7129b7f9781e@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <283f38d9-1142-60b6-0b84-7129b7f9781e@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Nov 27, 2018, at 9:50 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>=20
> On 11/27/18 3:50 PM, William Kucharski wrote:
>>=20
>> I was just double checking that this was meant to be more of a check =
done
>> before code elsewhere performs additional checks and does the actual =
THP
>> mapping, not an all-encompassing go/no go check for THP mapping.
>=20
> Yes, the code doing the actual mapping is still checking also =
alignment etc.

Thanks, yes, that is what I was getting at.
