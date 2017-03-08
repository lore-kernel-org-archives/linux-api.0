From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Re: [PATCH resent] uapi libc compat: allow non-glibc to
 opt out of uapi definitions
Date: Wed, 8 Mar 2017 12:29:53 -0500
Message-ID: <ada50de2-fe13-a087-af60-c975bf234a4d@redhat.com>
References: <20161111120820.GA435@nyan>
 <a360ec42-33ca-5e89-3d70-3b1c9a011c7f@redhat.com>
 <20170308162507.GY1520@brightrain.aerifal.cx>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <musl-return-11137-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
In-Reply-To: <20170308162507.GY1520@brightrain.aerifal.cx>
To: Rich Felker <dalias@aerifal.cx>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On 03/08/2017 11:25 AM, Rich Felker wrote:
> On Wed, Mar 08, 2017 at 10:53:00AM -0500, Carlos O'Donell wrote:
>> On 11/11/2016 07:08 AM, Felix Janda wrote:
>>> Currently, libc-compat.h detects inclusion of specific glibc headers,
>>> and defines corresponding _UAPI_DEF_* macros, which in turn are used in
>>> uapi headers to prevent definition of conflicting structures/constants.
>>> There is no such detection for other c libraries, for them the
>>> _UAPI_DEF_* macros are always defined as 1, and so none of the possibly
>>> conflicting definitions are suppressed.
>>>
>>> This patch enables non-glibc c libraries to request the suppression of
>>> any specific interface by defining the corresponding _UAPI_DEF_* macro
>>> as 0.
>>>
>>> This patch together with the recent musl libc commit
>>>
>>> http://git.musl-libc.org/cgit/musl/commit/?id=04983f2272382af92eb8f8838964ff944fbb8258
>>
>> Would it be possible to amend the musl patch to define the macros to 1.
> 
> I don't follow. They're defined to 0 explicitly to tell the kernel
> headers not to define their own versions of these structs, etc. since
> they would clash. Defining to 1 would have the opposite meaning.

My apologies, I must have misread the original musl patch.

Defining them to a known value is exactly what I was looking for.

The other outstanding questions remain.

-- 
Cheers,
Carlos.
