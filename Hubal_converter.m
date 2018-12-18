
function [] = Hubal_converter(DICOM_klasoru, Niftiler_nereye)
% Kullan�m �ekilleri:
% E�er dicom dosyalar�n�n bulundu�u klas�r ve hedef klas�r yolu biliniyorsa
% Hubal_converter(DICOM_klasoru, Niftiler_nereye);
% E�er aray�z ile klas�rlerin yerleri belirtilecekse
% Hubal_converter;
%
% Dicom klas�r�ndeki t�m denekler d�n��t�r�lecek
% E�er de�i�kenleri girmezsen aray�zden se�ersin.
% Rar dosyalar�n� g�rmez o y�zden d�n��t�rmeyeceklerin rar kalabilir.
% mcverter.exe konumunu DCMconverter de�i�kenine yazmal�s�n.
% 24.10.2018
% AliB

DCMconverter = 'D:\mri_tools\dicom_converter\mcverter.exe';
parametreler = ' -f nifti -q -j -x -u --fnformat=%%PI_%%SN_%%PR ';
% -f: Output format: fsl, spm, meta, nifti, analyze, or bv.
% -q: quiet mode
% -j: Save each subject to a separate directory
% -x: Save each series to a separate directory
% -u: Use patient id instead of patient name for output file
% %%PI_%%SN_%%PR: PatientId_SeriesNumber_ProtocolName

if nargin ~= 2
    DICOM_klasoru = uigetdir('','DICOM Klas�r�n� se�iniz');
    Niftiler_nereye = uigetdir('','Nifti dosyalar�n�n kaydedilece�i klas�r� se�iniz');
end

if ~isequal(DICOM_klasoru,0) && ~isequal(Niftiler_nereye,0)
    fprintf('DICOM klas�r� ve Nifti klas�r� se�ildi\n');
    tum_icerik = dir(DICOM_klasoru);
    tum_icerik(ismember( {tum_icerik.name}, {'.', '..'})) = []; %silinenler
    alt_klasorler = [tum_icerik.isdir];
    subj_dirs =  tum_icerik(alt_klasorler);
    if isempty(subj_dirs)
        fprintf('DICOM klas�r� i�inde denek klas�rleri bulunamad�.\n');
    else
        for subj_dirs_ind = 1 : length(subj_dirs)
            DICOMsubjdir = fullfile(DICOM_klasoru, subj_dirs(subj_dirs_ind).name);
            sonuc = system([DCMconverter, ' -o ', Niftiler_nereye, parametreler, DICOMsubjdir]);
            if ~sonuc
                fprintf('%d. denek klas�r�n�n d�n��t�rme i�lemi tamamland�\n',subj_dirs_ind);
            else
                fprintf('%s\nKlas�rdeki DICOM dosyalar� Nifti''ye d�n��t�r�lemedi!\n',subj_dirs(subj_dirs_ind).name);
            end
        end
    end
else
    fprintf('DICOM klas�r� ve/veya Nifti klas�r� se�ilmedi.\n');
end
