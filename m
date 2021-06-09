Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83D7C48BE0
	for <linux-api@archiver.kernel.org>; Wed,  9 Jun 2021 10:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDEA4608FE
	for <linux-api@archiver.kernel.org>; Wed,  9 Jun 2021 10:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhFIKjh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 9 Jun 2021 06:39:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234315AbhFIKjf (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 9 Jun 2021 06:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXhuyr8heOXQm5DhE+A2Fq3L85+vZLqOuEIP9E5CaCk=;
        b=FdW2fWtVmqwriFswDma8vccD5zTKHq8FosKyR3B93zkSEZOeUX6RmzIG7G9F+u4RgOB7/j
        ek6+4xglLwJHje6e0c3Pnqtid+rL07apdhOsyPLKzzF5rvWTb0Q3Uy8gNND8xTL09GcfJk
        FVk5l69EmSJwAPMGz1OoYsJf3hd8Rtk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-ELUYDFQZODiWQemU7ApKxw-1; Wed, 09 Jun 2021 06:37:39 -0400
X-MC-Unique: ELUYDFQZODiWQemU7ApKxw-1
Received: by mail-wr1-f70.google.com with SMTP id q15-20020adfc50f0000b0290111f48b865cso10572839wrf.4
        for <linux-api@vger.kernel.org>; Wed, 09 Jun 2021 03:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GXhuyr8heOXQm5DhE+A2Fq3L85+vZLqOuEIP9E5CaCk=;
        b=MspTRKHLr359ZJNzpns13UsqxIVbastCIhEM74hK9AS5L5HqhpdCKbbAUr+N9PDLdm
         jYYUw7YFkQfX4oaS+6iJqDsZYxsBdqqvRW9j19Hl9Qx+2rWdxWk53euRJ6pqC/c3RhbE
         UjY94aH8/+FuS1aK8J0op4W1qLitgt0qeltyBZxi8qrmcPf+pg9/AyYS/Eg57jTBR4ft
         Ln8Ncxs36XAN79IlkqQCrHodvdP09WJnD970Ohr9wkxzmNdxglpr1Ksm4FITdmAHXA4u
         5VQk2KuVlddsRYG37il+oO0uPz0kc+1SiBpgoM3oBRRGVYDctKiG0Aq0c/Y3Ii5I38Vf
         BbcQ==
X-Gm-Message-State: AOAM530llASe12kwFIyld7zWJGsN5TxYZBGfVkQ11K0ux/hS6oy0RnHe
        vrMOg8y25m6WEuZDWCeIe/v+VMV3Hs5/nGhoCLVcMlJWaWzo0jpfm1Ixfdu558VHLNJG99+iqcw
        vEUyOSVOsh6WhD3psl+jkVCu0lFUe+qzVmONIWUlb+t0CAoMFFAdFY8D08/sstPMYpNg7
X-Received: by 2002:a5d:4984:: with SMTP id r4mr27081052wrq.152.1623235058491;
        Wed, 09 Jun 2021 03:37:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxx5QPJlJibMJq5KkrldmC0yuk9Qgb+mpFY3QEuhdJz4/D402+HjHMF51cTVSM1EXp++YpYXw==
X-Received: by 2002:a5d:4984:: with SMTP id r4mr27081015wrq.152.1623235058237;
        Wed, 09 Jun 2021 03:37:38 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id l5sm5668999wmi.46.2021.06.09.03.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 03:37:37 -0700 (PDT)
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>
Cc:     Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
Date:   Wed, 9 Jun 2021 12:37:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On 28.05.21 16:58, James Bottomley wrote:
> On Thu, 2021-05-27 at 15:29 +0200, Greg KH wrote:
>> On Thu, May 27, 2021 at 03:23:03PM +0200, Christoph Lameter wrote:
>>> On Fri, 30 Apr 2021, Theodore Ts'o wrote:
>>>
>>>> I know we're all really hungry for some in-person meetups and
>>>> discussions, but at least for LPC, Kernel Summit, and
>>>> Maintainer's Summit, we're going to have to wait for another
>>>> year,
>>>
>>> Well now that we are vaccinated: Can we still change it?
>>>
>>
>> Speak for yourself, remember that Europe and other parts of the world
>> are not as "flush" with vaccines as the US currently is :(
> 
> The rollout is accelerating in Europe.  At least in Germany, I know
> people younger than me are already vaccinated. 

And I know people younger than you in Germany personally ( ;) ) that are 
not vaccinated yet and might not even get the first shot before 
September, not even dreaming about a second one + waiting until the 
vaccine is fully in effect.

So yes, sure, nobody can stop people that think the pandemic is over 
("we are vaccinated") from meeting in person. Just make sure to not 
ignore the poor souls that really won't be traveling this year, because 
"we are not vaccinated".

-- 
Thanks,

David / dhildenb

