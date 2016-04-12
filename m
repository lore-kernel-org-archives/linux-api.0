From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 6/7] crypto: KEYS - add generic handlers to symmetric
 key type
Date: Tue, 12 Apr 2016 15:20:05 -0700
Message-ID: <570D7495.7060801@intel.com>
References: <20160401013819.16799.38454.stgit@tstruk-mobl1>
 <20160401013745.16799.91093.stgit@tstruk-mobl1>
 <16339.1460499046@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16339.1460499046-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/12/2016 03:10 PM, David Howells wrote:
>> +/**
>> > + * asymmetric_key_verify_signature - invoke verify signature operation on a key
>> > + *			             of the asymmetric subtype
>> > + * @key: key from the system keyring
>> > + * @sig: signature to verify
>> > + *
>> > + * return: 0 on success or errno on failure
>> > + */
>> > +int asymmetric_key_verify_signature(const struct key *key,
>> > +				    const struct public_key_signature *sig)
> This is duplicating what's in signature.c in the same directory.

Right, should I remove it? Is the asymmetric_type.c good place to put all the operation
handlers into?
Thanks,
-- 
TS
