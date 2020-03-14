Return-Path: <SRS0=wgA+=5A=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B451AC0044D
	for <linux-api@archiver.kernel.org>; Sun, 15 Mar 2020 01:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EACA20637
	for <linux-api@archiver.kernel.org>; Sun, 15 Mar 2020 01:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584236353;
	bh=nlaaveyfQbhFKfwiAaphWpQDQEdEAujbuJUQUWFnHF0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=pp9mc6+M6EphhIcWRFItRMgX87lc3jEhrTsA2yZUHDuSwIAELdlJnj4qIAAa2oSQA
	 O7JjVMY9BmTxXYvhtuDZ7kw+dAW9Y3lZsaPC020RLhG3p0mmJ77vB7f0jPBhwv8LUw
	 GjYMAsgMxlnjeF4okXukApcrWT4i5qWmKp8+B4to=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCOBjN (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgCOBjM (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Sat, 14 Mar 2020 21:39:12 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E76F22071B;
        Sat, 14 Mar 2020 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584219193;
        bh=nlaaveyfQbhFKfwiAaphWpQDQEdEAujbuJUQUWFnHF0=;
        h=From:To:Cc:Subject:Date:From;
        b=0iSH8Q5D+Ml4kWit103vNhqqB1ao1wz8fX85tuNaSR98NmuiY+2hC1jyJD/ruJ/V1
         199VRhsa+r9bu1MzO7xz9Tr7s0TnpAj5smS4RburSHj7ylnB0x9tbam9/SzEee07yX
         pQtOWhG8kxmo09f3EZX3BsptKW71I9wsopcIgkek=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH 0/4] fscrypt: add ioctl to get file's encryption nonce
Date:   Sat, 14 Mar 2020 13:50:48 -0700
Message-Id: <20200314205052.93294-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

This patchset adds an ioctl FS_IOC_GET_ENCRYPTION_NONCE which retrieves
the nonce from an encrypted file or directory.

This is useful for automated ciphertext verification testing.

See patch #1 for more details.

Eric Biggers (4):
  fscrypt: add FS_IOC_GET_ENCRYPTION_NONCE ioctl
  ext4: wire up FS_IOC_GET_ENCRYPTION_NONCE
  f2fs: wire up FS_IOC_GET_ENCRYPTION_NONCE
  ubifs: wire up FS_IOC_GET_ENCRYPTION_NONCE

 Documentation/filesystems/fscrypt.rst | 11 +++++++++++
 fs/crypto/fscrypt_private.h           | 20 ++++++++++++++++++++
 fs/crypto/keysetup.c                  | 16 ++--------------
 fs/crypto/policy.c                    | 21 ++++++++++++++++++++-
 fs/ext4/ioctl.c                       |  6 ++++++
 fs/f2fs/file.c                        | 11 +++++++++++
 fs/ubifs/ioctl.c                      |  4 ++++
 include/linux/fscrypt.h               |  6 ++++++
 include/uapi/linux/fscrypt.h          |  1 +
 9 files changed, 81 insertions(+), 15 deletions(-)


base-commit: 98d54f81e36ba3bf92172791eba5ca5bd813989b
-- 
2.25.1

