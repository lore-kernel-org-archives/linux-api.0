From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Wed, 08 Jul 2015 15:49:03 +0300
Message-ID: <87pp42n7b4.fsf@ashishki-desk.ger.corp.intel.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com> <1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com> <CAAfSe-vDUdA+kY04-u-SXT-pdy_hn1hY1yG6-e-k_tbLsFzjKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAfSe-vDUdA+kY04-u-SXT-pdy_hn1hY1yG6-e-k_tbLsFzjKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, mathieu.poirier@linaro.org, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.lyra@gmail.com> writes:

>> +int __init stp_configfs_init(void)
>> +{
>> +       int err;
>> +
>> +       config_group_init(&stp_policy_subsys.su_group);
>> +       mutex_init(&stp_policy_subsys.su_mutex);
>> +       err = configfs_register_subsystem(&stp_policy_subsys);
>> +
>> +       return err;
>
> One small suggestion, is it better like this:
> return configfs_register_subsystem(&stp_policy_subsys);
> As such, we don't need the local variable "err" any more.

You are right, err doesn't serve any purpose here.

Thanks,
--
Alex
