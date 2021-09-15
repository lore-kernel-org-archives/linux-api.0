Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B21C433EF
	for <linux-api@archiver.kernel.org>; Wed, 15 Sep 2021 15:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0DB61244
	for <linux-api@archiver.kernel.org>; Wed, 15 Sep 2021 15:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhIOPvI (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:51:08 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:40871 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238338AbhIOPu6 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 15 Sep 2021 11:50:58 -0400
Date:   Wed, 15 Sep 2021 17:49:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=t-8ch.de; s=mail;
        t=1631720975; bh=p6kvwDo2CNzEb3gbLACm1Xe++OMnlnjagT/XqzSYwNc=;
        h=Date:From:To:Subject:From;
        b=BFnFQLX7KzxwmnmKMQ8hqsvLGLdmbT6zaREmpOVekyWRHFsKg6x3OV4O5jXVZPSgt
         RaYgDddkYBgBRKSGx6j+uuunRxcjmgLX6J5I1G5UiQ2Vs1J6njys0g3i9LJE9J8v1F
         z5GrPWQqrCQDgvkLGXI7U1k9cIdzi+2bcnIsU2/c=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [RFC] Expose request_module via syscall
Message-ID: <705fde50-37a6-49ed-b9c2-c9107cd88189@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi,

I would like to propose a new syscall that exposes the functionality of
request_module() to userspace.

Propsed signature: request_module(char *module_name, char **args, int flags);
Where args and flags have to be NULL and 0 for the time being.

Rationale:

We are using nested, privileged containers which are loading kernel modules.
Currently we have to always pass around the contents of /lib/modules from the
root namespace which contains the modules.
(Also the containers need to have userspace components for moduleloading
installed)

The syscall would remove the need for this bookkeeping work.

If this has a chance of getting accepted I would be happy to provide an
implementation.

Thanks,
Thomas
