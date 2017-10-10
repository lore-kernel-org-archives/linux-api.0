From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Re: [PATCHv3] uapi libc compat: add fallback for
 unsupported libcs
Date: Mon, 9 Oct 2017 20:30:12 -0700
Message-ID: <c5d7dedd-4f67-7fd6-bb49-b369803f9f4d@gmail.com>
References: <20170729140259.GA28081@nyan>
 <6896b985-151e-1dd9-ec91-7ce1300cc45b@hauke-m.de>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <musl-return-12004-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
In-Reply-To: <6896b985-151e-1dd9-ec91-7ce1300cc45b@hauke-m.de>
Content-Language: en-US
To: musl@lists.openwall.com, Hauke Mehrtens <hauke@hauke-m.de>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Carlos O'Donell <carlos@redhat.com>, Felix Janda <felix.janda@posteo.de>
List-Id: linux-api@vger.kernel.org

Le 10/01/17 à 03:37, Hauke Mehrtens a écrit :
> On 07/29/2017 04:02 PM, Felix Janda wrote:
>> libc-compat.h aims to prevent symbol collisions between uapi and libc
>> headers for each supported libc. This requires continuous coordination
>> between them.
>>
>> The goal of this commit is to improve the situation for libcs (such as
>> musl) which are not yet supported and/or do not wish to be explicitly
>> supported, while not affecting supported libcs. More precisely, with
>> this commit, unsupported libcs can request the suppression of any
>> specific uapi definition by defining the correspondings _UAPI_DEF_*
>> macro as 0. This can fix symbol collisions for them, as long as the
>> libc headers are included before the uapi headers. Inclusion in the
>> other order is outside the scope of this commit.
>>
>> All infrastructure in order to enable this fallback for unsupported
>> libcs is already in place, except that libc-compat.h unconditionally
>> defines all _UAPI_DEF_* macros to 1 for all unsupported libcs so that
>> any previous definitions are ignored. In order to fix this, this commit
>> merely makes these definitions conditional.
>>
>> This commit together with the musl libc commit
>>
>> http://git.musl-libc.org/cgit/musl/commit/?id=04983f2272382af92eb8f8838964ff944fbb8258
>>
>> fixes for example the following compiler errors when <linux/in6.h> is
>> included after musl's <netinet/in.h>:
>>
>> ./linux/in6.h:32:8: error: redefinition of 'struct in6_addr'
>> ./linux/in6.h:49:8: error: redefinition of 'struct sockaddr_in6'
>> ./linux/in6.h:59:8: error: redefinition of 'struct ipv6_mreq'
>>
>> Signed-off-by: Felix Janda <felix.janda@posteo.de>
>> ---
>> v3: Fix typos, add a comment to the file and use #ifndef.
>> v2: The only change to the previous version is the commit title and
>>     message.
> 
> Was this send to the wrong mailing lists? I would like to see this in
> the mainline kernel and I am wondering why it neither gets any comments
> nor shows up in linux-next.

Same here. Without such changes we cannot essentially build upstream
kernels in OpenWrt/LEDE using musl-libc without patching kernel headers,
which is really not great...
-- 
Florian
